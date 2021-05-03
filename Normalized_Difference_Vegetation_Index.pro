pro Normalized_Difference_Vegetation_Index
  tlb = widget_base( $  ;创建容器
    xsize = 800, $  ;容器宽度800像素
    ysize = 400, $  ;容器高度400像素
    tlb_frame_attr = 1, $  ;容器边框样式，无窗口放大缩小按钮
    title = 'Normalized_Difference_Vegetation_Index' $  ;容器标题
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
    value = 'Save', $
    xsize = 70, $
    ysize = 25, $
    xoffset = 350, $
    yoffset = 135, $
    uname = 'buttonOut' $  ;设置uname
    )
  labelIn = widget_label( $  ;创建文字控件
    base2, $  ;添加至base2
    value = 'Sensor:', $  ;文字内容
    xoffset = 10, $  ;横向位置
    yoffset = 80 $  ;纵向位置
    )

  sensor=widget_droplist($
    base2,$
    value=['TM/ETM+','OLI'],$
    Xsize=90,$
    ysize=25,$
    xoffset=70,$
    yoffset=75,$
    uname='sensor'$
    )
  xmanager, 'Normalized_Difference_Vegetation_Index', tlb, /no_block
end
pro Normalized_Difference_Vegetation_Index_event, ev
  ;获取textIn控件的id
  textIn = widget_info(ev.top, find_by_uname = 'textIn')
  textOut = widget_info(ev.top, find_by_uname = 'textOut')
  sensor = widget_info(ev.top,find_by_uname = 'sensor')
  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  case uname of
    'sensor' : begin
      index = widget_info(sensor,/droplist_select)
      case index of
        0: begin
          band1 = 3
          band2 = 2
        end
        1: begin
          band1 = 4
          band2 = 3
        end
      endcase
    end
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
    'buttonOut' :begin
      fileOut = dialog_pickfile(/write)  ;保存文件对话框
      widget_control, textOut, set_value = fileOut  ;修改文本框内容
    end
    'buttonRun' : begin  ;如果点击Run按钮，则执行以下操作
      widget_control, textIn, get_value = fileIn  ;获取文本框内容
      widget_control, textOut, get_value = fileOut  ;获取文本框内容
      index = widget_info(sensor,/droplist_select)
      case index of
        0: begin
          band1 = 3
          band2 = 2
        end
        1: begin
          band1 = 4
          band2 = 3
        end
      endcase
      pic = read_image(fileIn)  ;打开图像
      bnir = pic[band1,*,*]
      br = pic[band2,*,*]
      NDVI = (bnir-br)*1.0/(bnir+br)
      write_image, fileOut, 'TIFF', NDVI ;保存图像
      tmp = dialog_message('successful!', /info)  ;显示提示框
    end
  endcase
end