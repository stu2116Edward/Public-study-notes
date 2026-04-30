# Word使用宏修改字体

### 下载字体
在如下项目中选择自己喜欢的字体(.ttf格式)下载
https://github.com/jaywcjlove/free-font/  
https://wangchujiang.com/free-font/  
下载好后双击即可安装字体

### 在Word中开启宏 
在Word中，依次点击`文件`->`选项`->`信任中心`->`信任中心设置`->`宏设置`  
然后在跳出的界面中选择`启用所有宏设置`即可  


然后在，依次点击`视图`->`宏`  
输入宏项目名称为 `字体修改`，在跳出来的窗口中  
将我给的代码复制进去即可  
```
Sub 字体修改()
'
' 功能：随机改变字体、字号、行距
'
    Dim R_Character As Range
    Dim Cur_Paragraph As Paragraph
    
    ' 字号范围（正文推荐 10–14 磅，标题可稍大）
    Dim FontSize(4)
    FontSize(1) = 10
    FontSize(2) = 11
    FontSize(3) = 12
    FontSize(4) = 14

    ' 字体名称（请确保系统中存在这些字体）
    Dim FontName(3)
    FontName(1) = "快去写作业-CJK"
    FontName(2) = "苦累蛙圓體 CJK TC-Regular"
    FontName(3) = "ToneOZ-Tsuipita-TC"

    ' 行间距（单位：磅，推荐 15–25 之间）
    Dim ParagraphSpace(5)
    ParagraphSpace(1) = 15
    ParagraphSpace(2) = 18
    ParagraphSpace(3) = 20
    ParagraphSpace(4) = 22
    ParagraphSpace(5) = 25

    ' 关闭屏幕刷新，提升速度
    Application.ScreenUpdating = False

    ' 处理每个字符（字号、字体、无关上下偏移、适当字距）
    For Each R_Character In ActiveDocument.Characters
        VBA.Randomize

        ' 随机字体
        R_Character.Font.Name = FontName(Int(VBA.Rnd * 3) + 1)

        ' 随机字号
        R_Character.Font.Size = FontSize(Int(VBA.Rnd * 4) + 1)

        ' 关键修复：不再随机提升/降低位置（设为 0，避免显示不全）
        R_Character.Font.Position = 0

        ' 适当增加字符间距（0.5–1.5 磅），避免拥挤
        R_Character.Font.Spacing = VBA.Rnd * 1.5 + 0.3
    Next

    ' 处理段落行距
    For Each Cur_Paragraph In ActiveDocument.Paragraphs
        Cur_Paragraph.LineSpacing = ParagraphSpace(Int(VBA.Rnd * 5) + 1)
    Next

    Application.ScreenUpdating = True

    MsgBox "字体修改完成", vbInformation

End Sub
```
运行宏时，点击运行即可