/**
 * 学习通自动播放脚本
 */

// 当前小节
const activeElement = $(".posCatalog_select.posCatalog_active");
let unitCount = -1;

if (activeElement.length) {
    const chapterTitles = $(".posCatalog_select:has(.posCatalog_title)");
    const substantiveSiblings = $(".posCatalog_select").not(chapterTitles);

    unitCount = substantiveSiblings.index(activeElement) + 1;

    if (!substantiveSiblings.length || unitCount === -1) {
        console.warn("未找到有效的.posCatalog_select同级元素！");
        unitCount = -1;
    }
} else {
    console.error("未找到激活的小节元素！");
}

// 获取小节数量
const totalUnits = $(".posCatalog_level span em").length;

function main() {
    document.querySelector('li[title="视频"]').click();
    setTimeout(() => {
        const frameObj = $("iframe").eq(0).contents().find("iframe.ans-insertvideo-online");
        const videoNum = frameObj.length;

        if (videoNum > 0) {
            console.log(`%c当前小节中包含 ${videoNum} 个视频`, "color:#FF7A38;font-size:18px");
            watchVideos(frameObj, 0);
        } else {
            if (unitCount < totalUnits) {
                console.log(`%c当前小节中无视频，6秒后将跳转至下一节`, "font-size:18px");
                nextUnit();
            } else {
                console.log("%c好了好了，毕业了", "color:red;font-size:18px");
            }
        }
    }, 3000); // 3000毫秒（即3秒）后执行
}

function watchVideos(frameObj, videoIndex) {
    const videoElements = frameObj.contents().find("video#video_html5_api");
    const video = videoElements.eq(videoIndex);

    if (video.length === 0) {
        console.error("视频元素未找到！");
        nextUnit();
        return;
    }

    try {
        video[0].playbackRate = 2; // 设置倍速
    } catch (e) {
        console.error("倍速设置失败！此节可能有需要回复内容，不影响，跳至下一节。错误信息：" + e);
        nextUnit();
        return;
    }

    video[0].addEventListener('error', function (e) {
        if (e.target.error.code === 3) {
            console.error("视频文件损坏或不支持，尝试重新加载视频");
            // 尝试重新加载视频或跳过当前视频
            video[0].src = video[0].src; // 重新加载当前视频
            video[0].load(); // 重新加载后，需要调用load
            video[0].play(); // 重新播放
        } else {
            console.error("播放错误：", e);
            nextUnit(); // 如果不是MEDIA_ERR_DECODE错误，则跳至下一节
        }
    });

    video[0].play().catch(e => {
        if (e.name === "NotAllowedError") {
            console.log("用户交互后才能播放");
            simulateUserInteraction(() => {
                video[0].play().catch(e => console.error("播放失败：", e));
            });
        } else {
            console.error("播放失败：", e);
        }
    });

    console.log(`%c正在 ${video[0].playbackRate} 倍速播放第 ${videoIndex + 1} 个视频`, "font-size:18px");

    const checkVideoProgress = setInterval(() => {
        if (video[0].currentTime >= video[0].duration) {
            video[0].dispatchEvent(new Event("playdone"));
            clearInterval(checkVideoProgress);
            if (videoIndex < videoElements.length - 1) {
                watchVideos(frameObj, videoIndex + 1);
            } else {
                console.log("%c本小节视频播放完毕，等待跳转至下一小节...", "font-size:18px");
                nextUnit();
            }
        } else if (video[0].paused) {
            video[0].play();
        }
    }, 1000);
}

function simulateUserInteraction(callback) {
    // 模拟用户交互，例如点击视频元素
    const video = document.querySelector('video');
    if (video) {
        video.click();
        callback();
    }
}

function nextUnit() {
    console.log("%c即将进入下一节...", "color:red;font-size:18px");
    setTimeout(() => {
        scrollAndClickNext();
        console.log("%c行了别看了，我知道你学会了，下一节", "color:red;font-size:18px");
        if (++unitCount < totalUnits) {
            setTimeout(() => main(), 10000);
        }
    }, 6000);
}

function scrollAndClickNext() {
    $(document).scrollTop($(document).height() - $(window).height());
    $("#prevNextFocusNext").click();
    $(".nextChapter").eq(0).click();
    $("#prevNextFocusNext").click();
    $(".nextChapter").eq(0).click();
}

console.log(`%c 欢迎使用本脚本，此科目有 ${totalUnits} 个小节，当前为第 ${unitCount} 小节`, "color:#6dbcff", "color:red");
main();