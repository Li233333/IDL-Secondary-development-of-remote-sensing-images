pro Single_Channel_OLI
  tlb = widget_base( $  ;创建容器
    xsize = 800, $  ;容器宽度800像素
    ysize = 400, $  ;容器高度400像素
    tlb_frame_attr = 1, $  ;容器边框样式，无窗口放大缩小按钮
    title = 'Single_Channel_OLI' $  ;容器标题
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
    value = 'Open Input TIFF File', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 10 $  ;纵向位置
    )
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Open Input TIR TIFF File', $  ;文字内容
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
    uname = 'textInTIR' $  ;设置uname
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
    uname = 'buttonInTIR' $  ;设置uname
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
  xmanager, 'Single_Channel_OLI', tlb, /no_block
end
pro Single_Channel_OLI_event, ev
  ;获取textIn控件的id
  textIn = widget_info(ev.top, find_by_uname = 'textIn')
  textInTIR = widget_info(ev.top, find_by_uname = 'textInTIR')
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
    'buttonInTIR' : begin  ;如果点击Open按钮，则执行以下操作
      fileInTIR = dialog_pickfile(/read, filter = '*.*')  ;打开文件对话框
      widget_control, textInTIR, set_value = fileInTIR  ;修改文本框内容
      TIR = read_image(fileInTIR)  ;打开图像
    end
    'buttonOut' :begin
      fileOut = dialog_pickfile(/write)  ;保存文件对话框
      widget_control, textOut, set_value = fileOut  ;修改文本框内容
    end
    'buttonRun' : begin  ;如果点击Run按钮，则执行以下操作
      widget_control, textIn, get_value = fileIn  ;获取文本框内容
      widget_control, textOut, get_value = fileOut  ;获取文本框内容
      widget_control, textInTIR, get_value = fileInTIR  ;获取文本框内容
      pic = read_image(fileIn)  ;打开图像
      TIR = read_image(fileInTIR)  ;打开图像
      b5 = pic[4,*,*]
      b4 = pic[3,*,*]
      B10 = TIR[0,*,*]
      NDVI = (b5-b4)*1.0/(b5+b4)
      PV = (NDVI ge 0.7)*1.0+(NDVI le 0.05)*0+(NDVI gt 0.05 and NDVI lt 0.7)*((NDVI-0.05)*(0.70-0.05))
      EM = 0.004*PV + 0.0986
      C1 = 1.19104*10^8
      C2 = 14387.7
      K1 = 774.89
      K2 = 1321.08
      T = K2/alog(K1/B10+1)
      br = C2*((10.90^4/C1)+(1/10.90))
      r = T^2/(br* B10)
      d = T-(T^2/br)
      a11 = 0.0419
      a12 = 0.02916
      a13 = 1.01523
      a21 = -0.38333
      a22 = -1.50294
      a23 = 0.20324
      a31 = 0.00918
      a32 = 1.36072
      a33 = -0.27514
      w = 1.399
      Fi1 = a11*w^2+a12*w+a13
      Fi2 = a21*w^2+a22*w+a23
      Fi3 = a31*w^2+a32*w+a33
      Ts = r*(EM^(-1)*(Fi1*B10+Fi2)+Fi3)+d
      TC = Ts-273.15
      write_image, fileOut, 'TIFF', TC ;保存图像
      tmp = dialog_message('successful!', /info)  ;显示提示框
    end
  endcase
end