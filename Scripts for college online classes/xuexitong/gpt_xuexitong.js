(function() {
    const activeElement = $(".posCatalog_select.posCatalog_active");

    if (activeElement.length) {
        const chapterTitles = $(".posCatalog_select:has(.posCatalog_title)");
        const substantiveSiblings = $(".posCatalog_select").not(chapterTitles);
        let unitCount = substantiveSiblings.index(activeElement);
        unitCount += 1;

        if (!substantiveSiblings.length || unitCount === -1) {
            console.warn("未找到有效的.posCatalog_select同级元素！");
            unitCount = -1;
        }

        window.unitCount = unitCount;
    } else {
        console.error("未找到激活的小节元素！");
    }

    window.unit = $(".posCatalog_level span em").length;

    function watchVideo(frameObj, v_done) {
        var playDoneEvent = new Event("playdone");
        var v = frameObj.contents().eq(v_done).find("video#video_html5_api").get(0);

        try {
            v.playbackRate = 2;
        } catch (e) {
            console.error("倍速设置失败！此节可能有需要回复内容，不影响，跳至下一节。错误信息：" + e);
            window.app.nextUnit();
            return;
        }

        v.addEventListener("loadedmetadata", function() {
            v.play();
            console.log("正在 " + v.playbackRate + " 倍速播放第 " + (v_done + 1) + " 个视频");
        });

        v.addEventListener("error", function() {
            console.error("视频播放中断，重新打开当前视频");
            v.load();
            v.play();
        });

        var inter = setInterval(function() {
            if (v.currentTime >= v.duration) {
                dispatchEvent(playDoneEvent);
                clearInterval(inter);
            }
            if (v.paused) {
                v.play();
            }
        }, 1000);
    }

    function main() {
        document.querySelector('li[title="视频"]').click();
        setTimeout(function() {
            const frameObj = $("iframe").eq(0).contents().find("iframe.ans-insertvideo-online");
            const videoNum = frameObj.length;

            if (videoNum > 0) {
                console.log("当前小节中包含 " + videoNum + " 个视频");
                var v_done = 0;

                addEventListener("playdone", function() {
                    v_done++;
                    if (v_done < videoNum) {
                        watchVideo(frameObj, v_done);
                    } else {
                        console.log("本小节视频播放完毕，等待跳转至下一小节...");
                        if (window.app && window.app.nextUnit) {
                            window.app.nextUnit();
                        } else {
                            console.error("无法找到下一节的方法！");
                        }
                    }
                });

                watchVideo(frameObj, v_done);
            } else {
                if (window.unitCount < window.unit) {
                    console.log("当前小节中无视频，6秒后将跳转至下一节");
                    if (window.app && window.app.nextUnit) {
                        window.app.nextUnit();
                    } else {
                        console.error("无法找到下一节的方法！");
                    }
                } else {
                    console.log("好了好了，毕业了");
                }
            }
        }, 3000);
    }

    console.log("欢迎使用本脚本，此科目有 " + window.unit + " 个小节，当前为第 " + window.unitCount + " 小节");
    main();
})();
