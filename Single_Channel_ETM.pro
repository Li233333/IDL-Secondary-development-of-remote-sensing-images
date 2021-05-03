pro Single_Channel_ETM
  tlb = widget_base( $  ;创建容器
    xsize = 800, $  ;容器宽度800像素
    ysize = 400, $  ;容器高度400像素
    tlb_frame_attr = 1, $  ;容器边框样式，无窗口放大缩小按钮
    title = 'Single Channel ETM+' $  ;容器标题
    )
  widget_control, tlb, /realize  ;显示容器
  btnRun = widget_button( $  ;创建按钮
    tlb, $  ;将按钮添加至tlb容器中
    value = 'Run', $  ;设置按钮上的文字
    xsize = 100, $  ;按钮宽度
    ysize = 30, $  ;按钮高度
    xoffset = 600, $  ;按钮横向位置
    yoffset = 350 ,$  ;按钮纵向位置
    uname = 'buttonRun'$
    )
  base1 = widget_base( $  ;创建base1
    tlb, $  ;将base1添加至tlb容器
    xsize = 300, $  ;base宽度
    ysize = 350, $  ;base高度
    xoffset = 25, $  ;横向位置
    yoffset = 25, $  ;纵向位置
    frame = 1 $  ;base1边框样式
    )
  base2 = widget_base( $  ;创建base2
    tlb, $  ;将base2添加至tlb容器
    xsize = 425, $  ;base宽度
    ysize = 300, $  ;base高度
    xoffset = 350, $  ;横向位置
    yoffset = 25, $  ;纵向位置
    frame = 1 $  ;base2边框样式
    )
  draw = widget_draw( $  ;创建图像显示控件
    base1, $  ;将控件添加至base1
    xsize = 280, $  ;控件宽度
    ysize = 340, $  ;控件高度
    xoffset = 10, $  ;横向位置
    yoffset = 5 $  ;纵向位置
    )
  widget_control, draw, get_value = win  ;获取图像控件的窗口ID
  widget_control, tlb, set_uvalue = win  ;保存图像控件的窗口ID
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Open Input File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 10 $  ;纵向位置
    )
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Open Input T6 File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 65 $  ;纵向位置
    )
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Output File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 120 $  ;纵向位置
    )
  textIn = widget_text( $
    base2, $
    xsize = 40, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 25, $
    uname = 'textIn' $  ;设置uname
    )
  textIn = widget_text( $
    base2, $
    xsize = 40, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 80, $
    uname = 'textInT6' $  ;设置uname
    )
  textIn = widget_text( $
    base2, $
    xsize = 40, $
    ysize = 1, $
    xoffset = 10, $
    yoffset = 135, $
    uname = 'textOut' $  ;设置uname
    )
  btnOpen = widget_button( $
    base2, $
    value = 'Open', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 25, $
    uname = 'buttonIn' $  ;设置uname
    )
  btnOpen = widget_button( $
    base2, $
    value = 'Open', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 80, $
    uname = 'buttonInT6' $  ;设置uname
    )
  btnOpen = widget_button( $
    base2, $
    value = 'Save', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 135, $
    uname = 'buttonOut' $  ;设置uname
    )
  xmanager, 'Single_Channel_ETM', tlb, /no_block
end
pro Single_Channel_ETM_event, ev
  ;获取textIn控件的id
  textIn = widget_info(ev.top, find_by_uname = 'textIn')
  textInT6 = widget_info(ev.top, find_by_uname = 'textInT6')
  textOut = widget_info(ev.top, find_by_uname = 'textOut')
  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  case uname of
    'buttonIn' : begin  ;如果点击Open按钮，则执行以下操作
      fileIn = dialog_pickfile(/read, filter = '*.*')  ;打开文件对话框
      widget_control, textIn, set_value = fileIn  ;修改文本框内容
      pic = read_image(fileIn)  ;打开图像
      ;图像缩放
      display = bytarr(3, 280, 340)
      display[0, *, *] = congrid(reform(pic[0, *, *]), 280, 340)
      display[1, *, *] = congrid(reform(pic[1, *, *]), 280, 340)
      display[2, *, *] = congrid(reform(pic[2, *, *]), 280, 340)
      widget_control, ev.top, get_uvalue = win
      wset, win
      tvscl, display, /true  ;显示图像
    end
    'buttonInT6' : begin  ;如果点击Open按钮，则执行以下操作
      fileInT6 = dialog_pickfile(/read, filter = '*.*')  ;打开文件对话框
      widget_control, textInT6, set_value = fileInT6  ;修改文本框内容
      T6 = read_image(fileInT6)  ;打开图像
    end
    'buttonOut' :begin
      fileOut = dialog_pickfile(/write)  ;保存文件对话框
      widget_control, textOut, set_value = fileOut  ;修改文本框内容
    end
    'buttonRun' : begin  ;如果点击Run按钮，则执行以下操作
      widget_control, textIn, get_value = fileIn  ;获取文本框内容
      widget_control, textOut, get_value = fileOut  ;获取文本框内容
      widget_control, textInT6, get_value = fileInT6  ;获取文本框内容
      pic = read_image(fileIn)  ;打开图像
      T6 = read_image(fileInT6)  ;打开图像
      b4 = pic[3,*,*]
      b3 = pic[2,*,*]
      Lsen = T6[0,*,*]
      NDVI = (b4-b3)*1.0/(b4+b3)
      PV = (NDVI ge 0.7)*1.0+(NDVI le 0.05)*0+(NDVI gt 0.05 and NDVI lt 0.7)*((NDVI-0.05)*(0.70-0.05))
      EM = 0.004*PV + 0.0986
      C1 = 1.19104*10^8
      C2 = 14387.7
      K1 = 666.09
      K2 = 1282.71
      T = K2/alog(K1/Lsen+1)
      br = C2*((11.3350^4/C1)+(1/11.3350))
      r = T^2/(br* Lsen)
      d = T-(T^2/br)
      a11 = 0.14714
      a12 = -0.15583
      a13 = 1.1234
      a21 = -1.1836
      a22 = -0.37607
      a23 = -0.52894
      a31 = -0.04554
      a32 = 1.18719
      a33 = -0.39071
      w = 1.399
      Fi1 = a11*w^2+a12*w+a13
      Fi2 = a21*w^2+a22*w+a23
      Fi3 = a31*w^2+a32*w+a33
      Ts = r*(EM^(-1)*(Fi1*Lsen+Fi2)+Fi3)+d
      TC = Ts-273.15
      write_image, fileOut, 'TIFF', TC ;保存图像
      tmp = dialog_message('successful!', /info)  ;显示提示框
    end
  endcase
end