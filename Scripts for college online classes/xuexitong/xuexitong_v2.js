/**
 * 学习通自动播放脚本
 */

(function() {
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
        return;
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
                var v_done = 0;
                // 播放
                playVideo(frameObj, v_done);
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

    function playVideo(frameObj, v_done) {
        const videoElements = frameObj.contents().find("video#video_html5_api");
        const video = videoElements.eq(v_done);

        if (video.length === 0) {
            console.error("视频元素未找到！");
            nextUnit();
            return;
        }

        const v = video[0];

        try {
            v.playbackRate = 2; // 设置倍速
        } catch (e) {
            console.error("倍速设置失败！此节可能有需要回复内容，不影响，跳至下一节。错误信息：" + e);
            nextUnit();
            return;
        }

        // 尝试播放视频，如果失败则模拟用户交互后重试
        const play = () => {
            v.play().catch(e => {
                if (e.name === "NotAllowedError") {
                    console.log("用户交互后才能播放");
                    simulateUserInteraction(play);
                } else if (e.name === "AbortError") {
                    console.log("播放被中断，尝试重新播放");
                    play(); // 重新尝试播放
                } else {
                    console.error("播放失败：", e);
                    nextUnit();
                }
            });
        };

        play();

        console.log(`%c正在 ${v.playbackRate} 倍速播放第 ${v_done + 1} 个视频`, "font-size:18px");

        const checkVideoProgress = setInterval(() => {
            if (v.currentTime >= v.duration) {
                clearInterval(checkVideoProgress);
                v_done++;
                if (v_done < videoElements.length) {
                    playVideo(frameObj, v_done);
                } else {
                    console.log("%c本小节视频播放完毕，等待跳转至下一小节...", "font-size:18px");
                    nextUnit();
                }
            } else if (v.paused) {
                play();
            }
        }, 1000);
    }

    function simulateUserInteraction(callback) {
        // 模拟用户交互，例如点击视频元素
        const video = document.querySelector('video');
        if (video) {
            // 某些视频可能需要实际的点击事件才能播放
            // 这里我们尝试模拟一个点击事件
            const event = new MouseEvent('click', {
                bubbles: true,
                cancelable: true,
                view: window
            });
            video.dispatchEvent(event);
            callback();
        }
    }

    function nextUnit() {
        console.log("%c即将进入下一节...", "color:red;font-size:18px");
        setTimeout(() => {
            scrollAndClickNext();
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

    // 防止脚本直接运行在页面中，造成未定义方法和变量的调用
    window.learningAutoPlay = {
        nextUnit: nextUnit,
        playVideo: playVideo,
        simulateUserInteraction: simulateUserInteraction
    };
})();
