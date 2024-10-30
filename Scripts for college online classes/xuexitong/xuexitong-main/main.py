import time
import traceback
from selenium import webdriver
from selenium.common import TimeoutException, NoSuchElementException
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# 设置浏览器驱动路径
driver_path = "/Users/nick/Desktop/ChromeDriver/chromedriver/chromedriver"
service = Service(driver_path)
driver = webdriver.Chrome(service=service)

# 全局变量
programRunningTime = 0
totalTitle = {"Chapter 1": "Title 1", "Chapter 2": "Title 2"}  # 示例
flag = False

def videoPlay(title=None):
    endPlayTime = "00:00"  # 初始化结束时间
    global programRunningTime
    global flag
    try:
        # 打开课程页面
        if flag == False :
            course_url = "https://mooc1.chaoxing.com/mycourse/studentstudy?chapterId=890225734&courseId=245132854&clazzid=103411235&cpi=413412582&enc=7e7df62a63de59c6ac67c11616c476f5&mooc2=1&openc=bb84cbd960a5e4267d4f25e7ace9f92c"
            flag = True
        else:
            current_url = driver.current_url
            course_url = current_url
        driver.get(course_url)
        wait = WebDriverWait(driver, 20)

        outer_iframe = wait.until(EC.presence_of_element_located((By.ID, "iframe")))
        driver.switch_to.frame(outer_iframe)
        print("成功切换到外层 iframe")

        inner_iframe = wait.until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "iframe.ans-insertvideo-online")))
        driver.switch_to.frame(inner_iframe)
        print("成功切换到内层 iframe")

        # 播放视频
        play_button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, ".vjs-big-play-button")))
        play_button.click()
        print("播放按钮点击成功")

        while True:
            # 检查是否有题目弹窗
            if checkForQuizPopup():
                handleQuizPopup()  # 处理题目弹窗

            # 获取播放进度条
            progress = driver.find_element(By.CSS_SELECTOR,
                                           '[class="vjs-play-progress vjs-slider-bar"]').get_attribute("style")
            time.sleep(1)
            programRunningTime += 1  # 记录程序运行秒数

            if endPlayTime == "00:00":
                endPlayTime = driver.find_element(By.CSS_SELECTOR, '.vjs-duration-display').text  # 获取视频结束时间

            if progress.split(" ")[1] == "100%;":  # 当播放进度达到100%
                print("视频播放结束")
                nextChapterChange()
                print("点击下一章")
                break
        if checkQuestions(driver):
            print("需要做题")
        else:
            print("不需要")
        time.sleep(1)
        print("选择题处理完毕，进入下一章学习")
        if checkConfirmPopup():
            submit_button = wait.until(EC.element_to_be_clickable((By.ID, 'popok')))
            submit_button.click()
        time.sleep(3)
        if checkForSubmitPopup():
            print("弹出提交弹窗")
        else:
            print("未弹出提交弹窗")
        if checkForNextChapter():
            print("弹出提交弹窗2")
        else:
            print("未弹出提交弹窗2")
        nextChapterChange()
        videoPlay()

    except TimeoutException as e:
        print("未找到指定元素", e)
        traceback.print_exc()

    except Exception as e:
        print("遇到异常：", e)
        traceback.print_exc()

def checkForNextChapter():
    try:
        # 查找 "下一节" 按钮
        next_button = driver.find_element(By.CSS_SELECTOR, '.jb_btn.jb_btn_92.fr.fs14.nextChapter')
        if next_button.is_displayed():  # 检查按钮是否可见
            next_button.click()  # 点击按钮
            return True
        else:
            return False
    except Exception:
        return False


def checkForSubmitPopup():
    try:
        # 检查提交弹窗是否存在（通过检查下一节按钮是否显示）
        next_button = driver.find_element(By.CSS_SELECTOR, '.bluebtn02.prebutton.nextChapter')
        if next_button.is_displayed():  # 检查按钮是否可见
            next_button.click()  # 点击下一节按钮
            return True
    except Exception:
        return False


def checkForQuizPopup():
    try:
        # 检查题目弹窗是否存在
        driver.find_element(By.CSS_SELECTOR, '.ans-videoquiz-opt')
        return True
    except Exception:
        return False

def checkConfirmPopup():
    try:
        time.sleep(2)
        driver.find_element(By.CSS_SELECTOR, '.popDiv.wid440.Marking')
        return True
    except Exception:
        return False

def checkQuestions(driver):
    try:
        handleQuestions(driver)
        return False
    except Exception:
        return True

def handleQuestions(driver):

    try:
        wait = WebDriverWait(driver, 3)
        # 切换到第一个 iframe
        driver.switch_to.frame("iframe")
        print("切换到第一个 iframe")

        # 如果需要，可以等待第一个 iframe 的内容加载
        time.sleep(2)  # 根据实际情况调整时间

        driver.switch_to.frame(driver.find_element(By.CSS_SELECTOR, "iframe[src*='work/index.html']"))
        print("切换到第二个 iframe")

        # 切换到目标 iframe（frame_content）
        driver.switch_to.frame("frame_content")
        print("切换到 frame_content iframe")
        # 确保页面完全加载
        time.sleep(3)
        questions = driver.find_elements(By.CSS_SELECTOR, '.ZyBottom .singleQuesId')

        for question in questions:
            # 判断题型
            question_type_element = question.find_element(By.CSS_SELECTOR, 'li[role="radio"], li[role="checkbox"]')
            question_type = question_type_element.get_attribute("qtype")  # 获取题目的 qtype 属性
            if question_type == "0":
                single_choice = driver.find_element(By.CSS_SELECTOR,
                                                    '.ZyBottom .singleQuesId li[role="radio"] span[data="A"]')
                single_choice.click()
                print("单选题选A")
            elif question_type == "3":
                true_option = question.find_element(By.CSS_SELECTOR, 'li[role="radio"] span[data="true"]')
                true_option.click()
                print("判断题：选择了 True")
            else:
                answer_A = question.find_element(By.CSS_SELECTOR, 'li[role="checkbox"] span[data="A"]')
                answer_A.click()
                time.sleep(1)
                answer_B = question.find_element(By.CSS_SELECTOR, 'li[role="checkbox"] span[data="B"]')
                answer_B.click()
                print("多选题：选择了选项 AB")

        # 查找并点击提交按钮
        try:
            submit_button = wait.until(
                EC.element_to_be_clickable((By.CSS_SELECTOR, '.btnSubmit.workBtnIndex'))
            )
            submit_button.click()
            print("提交按钮点击成功")

            # 等待提交操作完成
            time.sleep(2)
        except TimeoutException as e:
            print("未找到提交按钮", e)
            traceback.print_exc()
    except TimeoutException as e:
        print("处理选择题时未找到指定元素", e)
        traceback.print_exc()

    except Exception as e:
        print("遇到异常：", e)
        traceback.print_exc()

    finally:
        # 切换回主内容
        driver.switch_to.default_content()

def handleQuizPopup():
    try:
        wait = WebDriverWait(driver, 5)

        # 处理题目弹窗，查找所有选项
        quiz_options = driver.find_elements(By.CSS_SELECTOR, '.ans-videoquiz-opt')
        # 遍历 quiz_options 列表中的每个选项
        for option in quiz_options:
            # 在每个选项中查找 input 元素 (radio 或 checkbox)
            inputs = option.find_elements(By.CSS_SELECTOR, 'input[type="radio"], input[type="checkbox"]')
            # 处理每个 input 元素
            for input_element in inputs:
                if input_element.get_attribute('type') == 'radio':
                    print("这是单选题")
                    handle_single_choice(quiz_options, wait)
                elif input_element.get_attribute('type') == 'checkbox':
                    print("这是多选题")
                    handle_multiple_choice(quiz_options, wait)
                else:
                    print("未知的题型")

        time.sleep(2)  # 休眠2秒，确保提交完成
        checkAndClickContinueButton()
    except TimeoutException as e:
        print("处理题目弹窗时未找到指定元素", e)
        traceback.print_exc()

    except Exception as e:
        print("遇到异常：", e)
        traceback.print_exc()


def checkAndClickContinueButton():
    try:
        # 查找 "继续学习" 按钮
        continue_button = driver.find_element(By.ID, "videoquiz-continue")
        if continue_button.is_displayed():
            continue_button.click()
        else:
            print("继续学习按钮不可见")

    except NoSuchElementException:
        # 如果没有找到按钮
        print("继续学习按钮不存在，忽略")


def handle_single_choice(quiz_options, wait):
    ans_list = ['A', 'B', 'C', 'D']
    for ans in ans_list:
        is_answer_correct = try_answer(quiz_options, ans, wait)
        if not is_answer_correct:
            print("选项{ans}错误")

def handle_multiple_choice(quiz_options, wait):

    for option in quiz_options:
        option_text = option.text

        if 'A' in option_text :
            checkbox = option.find_element(By.CSS_SELECTOR, 'input[type="checkbox"]')
            checkbox.click()

        if 'B' in option_text :
            checkbox = option.find_element(By.CSS_SELECTOR, 'input[type="checkbox"]')
            checkbox.click()

        if 'C' in option_text:
            checkbox = option.find_element(By.CSS_SELECTOR, 'input[type="checkbox"]')
            checkbox.click()

        if 'D' in option_text:
            checkbox = option.find_element(By.CSS_SELECTOR, 'input[type="checkbox"]')
            checkbox.click()

        if 'E' in option_text:
            checkbox = option.find_element(By.CSS_SELECTOR, 'input[type="checkbox"]')
            checkbox.click()

            break

    # 提交答案
    submit_button = wait.until(EC.element_to_be_clickable((By.ID, 'videoquiz-submit')))
    submit_button.click()
    print("多选题提交成功")

    # 等待一小段时间，检查是否正确
    time.sleep(2)

def try_answer(quiz_options, answer, wait):
    try:
        # 遍历选项并选择指定的答案
        for option in quiz_options:
            option_text = option.text
            if answer in option_text:
                radio_button = option.find_element(By.CSS_SELECTOR, 'input[type="radio"]')
                radio_button.click()
                print(f"尝试选择选项 {answer}")

                # 提交答案
                submit_button = wait.until(EC.element_to_be_clickable((By.ID, 'videoquiz-submit')))
                submit_button.click()
                print("提交按钮点击成功")

                # 等待一小段时间，检查弹窗是否消失
                time.sleep(2)

                # 检查题目弹窗是否仍然存在，如果存在，说明答案不正确
                if checkForQuizPopup():
                    print(f"选项 {answer} 错误")
                    return False
                else:
                    print(f"选项 {answer} 正确")
                    return True

    except Exception as e:
        print(f"提交答案 {answer} 时遇到异常: {e}")
        traceback.print_exc()

    return False


def nextChapterChange():
    global totalTitle
    wait = WebDriverWait(driver, 10)
    driver.switch_to.default_content()

    # 查找“下一节”按钮并点击
    next_button = wait.until(EC.element_to_be_clickable((By.ID, "prevNextFocusNext")))
    next_button.click()
    print("点击 '下一节' 按钮成功")
    time.sleep(2)  # 休眠2秒，等页面完全打开再进行下一步操作
    # 等待页面加载完成并检查新页面的加载情况
    wait.until(EC.presence_of_element_located((By.ID, "iframe")))  # 动态等待 iframe 加载
    print("下一节页面加载完成")

# 主函数
def main():
    try:
        videoPlay()
    except Exception as e:
        print(f"脚本运行出错: {e}")
        traceback.print_exc()

if __name__ == "__main__":
    main()
