pro testWidget2
  tlb = widget_base( $ ; 创建容器
    xsize = 800,$ ;容器宽度800像素
    ysize = 400,$ ;容器高度400像素
    tlb_frame_attr = 1,$ ;容器边框样式，无窗口放大缩小按钮
    title = 'off/off'$ ; 容器标题
    )

  btnRun = widget_button( $ ;创建按钮
    tlb,$ ;将按钮添加至tlb容器中
    value = 'run',$ ; 设置按钮上的文字
    xsize = 100,$ ; 按钮高度
    ysize = 30,$ ; 按钮宽度
    xoffset = 500,$ ; 按钮横向位置
    yoffset = 350,$ ; 按钮纵向位置
    uname = 'buttonRun' $ ;设置uname
    )
  btnNext=widget_button($
    tlb,$
    value='next',$ ; 设置按钮上的文字
    xsize=100,$ ;设置按钮高度
    ysize=30,$ ;设置按钮宽度
    xoffset=650,$  ; 按钮横向位置
    yoffset=350,$  ; 按钮纵向位置
    uname='buttonNext'$;设置uname
    )
  base1 = widget_base( $ ;创建base1
    tlb, $ ;将base1添加至tlb容器
    xsize = 300,$ ;base宽度
    ysize = 350,$ ;base高度
    xoffset = 25,$ ;横向宽度
    yoffset = 25,$ ;纵向宽度
    frame = 1 $ ;base1边框样式
    )
  base2 = widget_base( $ ;创建base2
    tlb, $ ; 将base2添加至tlb容器
    xsize = 425,$ ; base宽度
    ysize = 300,$ ; base高度
    xoffset = 350,$ ; 横向位置
    yoffset = 25,$ ; 纵向位置
    frame = 1 $;base2边框模式
    )

  widget_control,tlb,/realize ;  显示容器

  draw = widget_draw( $ ; 创建图像显示控件
    base1, $ ; 将控件添加至base1
    xsize = 280,$ ; 控件宽度
    ysize = 340,$ ; 控件高度
    xoffset = 10,$ ; 横向位置
    yoffset = 5 $ ; 纵向位置
    )
  widget_control,draw,get_value = win ; 获取图像控件的窗口ID
  widget_control,tlb,set_uvalue = win ; 保存图像控件的窗口ID
  labelIn = widget_label( $ ; 创建文字控件
    base2, $ ; 添加至base2
    value = 'openmask', $ ;文字内容
    xoffset = 10,$ ;横向位置
    yoffset = 10 $ ; 纵向位置
    )
  labelIn = widget_label( $ ; 创建文字控件
    base2, $ ; 添加至base2
    value = 'tiaodaiyingxiang', $ ;文字内容
    xoffset = 10,$ ;横向位置
    yoffset = 70 $ ; 纵向位置
    )
   labelIn = widget_label( $ ; 创建文字控件
    base2, $ ; 添加至base2
    value = 'bufentiaodaiyingxiang1', $ ;文字内容
    xoffset = 10,$ ;横向位置
    yoffset = 130 $ ; 纵向位置
    )
    labelIn = widget_label( $ ; 创建文字控件
    base2, $ ; 添加至base2
    value = 'bufentiaodaiyingxiang2', $ ;文字内容
    xoffset = 10,$ ;横向位置
    yoffset = 190 $ ; 纵向位置
    )

  labelIn = widget_label( $ ; 创建文字控件
    base2, $ ; 添加至base2
    value = 'Choose Output File', $ ;文字内容
    xoffset = 10,$ ;横向位置
    yoffset = 250 $ ; 纵向位置
    )


  text1 = widget_text($
    base2,$
    xsize=50,$
    ysize=1,$
    xoffset=10,$
    yoffset=30,$
    uname='text1' $ ;设置uname参数
    )
  text2 = widget_text($
    base2,$
    xsize=50,$
    ysize=1,$
    xoffset=10,$
    yoffset=90,$
    uname='text2' $ ;设置uname参数
    )

  text3 = widget_text($
    base2,$
    xsize=50,$
    ysize=1,$
    xoffset=10,$
    yoffset=150,$
    uname='text3' $ ;设置uname参数
    )
    text4 = widget_text($
    base2,$
    xsize=50,$
    ysize=1,$
    xoffset=10,$
    yoffset=210,$
    uname='text4' $ ;设置uname参数
    )
  text4 = widget_text($
    base2,$
    xsize=50,$
    ysize=1,$
    xoffset=10,$
    yoffset=270,$
    uname='text5' $ ;设置uname参数
    )
  btnChoose=widget_button($
    base2,$
    value='choose',$
    xsize=70,$
    ysize=25,$
    xoffset=350,$
    yoffset=270,$
    uname='button3'$;设置uname
    )

  btnOpen=widget_button($
    base2,$
    value='open',$
    xsize=70,$
    ysize=25,$
    xoffset=350,$
    yoffset=30,$
    uname='button1'$;设置uname
    )
  btnChoose=widget_button($
    base2,$
    value='open',$
    xsize=70,$
    ysize=25,$
    xoffset=350,$
    yoffset=90,$
    uname='button2'$;设置uname
    )
    btnChoose=widget_button($
    base2,$
    value='open',$
    xsize=70,$
    ysize=25,$
    xoffset=350,$
    yoffset=150,$
    uname='button3'$;设置uname
    )
    btnChoose=widget_button($
    base2,$
    value='open',$
    xsize=70,$
    ysize=25,$
    xoffset=350,$
    yoffset=210,$
    uname='button4'$;设置uname
    )
  xmanager, 'testWidget2',tlb,/no_block  ;事件获取语句
end


pro testWidget2_event,ev  ;定义事件响应函数
  FORWARD_FUNCTION ENVI_Batch_Init,ENVI_FILE_QUERY,ENVI_OPEN_FILE,ENVI_DOIT,envi_write_envi_file,ENVI_ENTER_DATA   ;调用ENVI中函数
  COMPILE_OPT idl2
  text1=widget_info(ev.top,find_by_uname='text1');获取text1控件的id
  text2=widget_info(ev.top,find_by_uname='text2');获取text2控件的id
  text3=widget_info(ev.top,find_by_uname='text3');获取text3控件的id
  uname=widget_info(ev.id,/uname);获取触发事件的控件uname
  case uname of

    'button1':begin   ;点击button1执行以下操作
      ENVI,  /restore_base_save_file
      ENVI_Batch_Init
      fileIn1=dialog_pickfile(/read)
      ENVI_OPEN_FILE,fileIn1,R_FID=fid
      ENVI_FILE_QUERY,fid,fileIn1=filename,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      widget_control,text1,set_value = fileIn1;修改文本框的内容
      pos=indgen(nb)
      priimage=uintarr(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN   ;执行以下循环
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        priimage[*,*,i]=temp
      ENDFOR
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,temp
    end

    'button2':begin ;点击button2执行以下操作
      fileIn2=DIALOG_PICKFILE(/read)
      ENVI_OPEN_FILE,fileIn2,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      widget_control,text2,set_value = fileIn2;修改文本框的内容
      pos=INDGEN(nb)
      fillimage=UINTARR(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        fillimage[*,*,i]=temp
      ENDFOR
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,temp
    end
    'button3':begin ;点击button3执行以下操作
      fileIn2=DIALOG_PICKFILE(/read)
      ENVI_OPEN_FILE,fileIn2,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      widget_control,text3,set_value = fileIn2;修改文本框的内容
      pos=INDGEN(nb)
      fillimage=UINTARR(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        fillimage[*,*,i]=temp
      ENDFOR
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,temp
    end
    'button4':begin ;点击button4执行以下操作
      fileIn2=DIALOG_PICKFILE(/read)
      ENVI_OPEN_FILE,fileIn2,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      widget_control,text4,set_value = fileIn2;修改文本框的内容
      pos=INDGEN(nb)
      fillimage=UINTARR(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        fillimage[*,*,i]=temp
      ENDFOR
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,temp
    end

    'button5':begin ;如果点击choose按钮，则执行以下操作
      fileOut = dialog_pickfile(/write); 保存文件对话框
      widget_control,text3,set_value = fileOut ;修改文本框内容
    end

    'buttonRun':begin
      ;FORWARD_FUNCTION ENVI_GET_DATA,ENVI_Batch_Init,ENVI_FILE_QUERY,ENVI_OPEN_FILE,ENVI_DOIT,ENVI_ENTER_DATA
      ;COMPILE_OPT idl2
      widget_control,text1,get_value=fileIn1;获取文本框内容
      widget_control,text2,get_value=fileIn2;获取文本框内容
      widget_control,text3,get_value=fileOut
      envi,/restore_base_save_files
      envi_batch_init;初始化ENVI二次开发模式
      ENVI_OPEN_FILE,fileIn1,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      pos=indgen(nb)
      priimage=uintarr(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        priimage[*,*,i]=temp
      ENDFOR

      ;input data
      ;the slc off data
      ; fileIn2=DIALOG_PICKFILE(/read)
      ENVI_OPEN_FILE,fileIn2,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      pos=INDGEN(nb)
      fillimage=UINTARR(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        fillimage[*,*,i]=temp
      ENDFOR



      sized=SIZE(priimage,/N_DIMENSIONS )
      IF  sized EQ 2 then begin
        temp=priimage
      ENDIF ELSE BEGIN
        temp=reform(priimage[*,*,1],ns,nl)
      ENDELSE

      mask=~(~temp)
      ;parameter for phase one
      para_n=140
      para_win=17
      para_winmax=31

      ;test the algorithm
      tol=0.01
      gain=1
      bias=0
      x1=SIZE(mask,/dimensions)
      x2=SIZE(priimage,/dimensions)
      x3=SIZE(fillimage,/dimensions)
      ;剔除高饱和度的数据 排除条带区域
      imask=REFORM(mask, x1[0]*x1[1])
      ind1=WHERE(imask NE 0)
      ipri_image = REFORM(priimage, x2[0]*x2[1]*6)
      ifill_imag = REFORM(fillimage, x3[0]*x3[1]*6)

      ;求出增益与偏执
      mup=MEAN(ipri_image[ind1])
      muf=MEAN(ifill_imag[ind1])
      thetap=VARIANCE(ipri_image[ind1])
      thetaf=VARIANCE(ifill_imag[ind1])
      gain=thetap/thetaf    ;计算gains
      if gain>3||gain<1/3 then gain=1
      bias=mup-muf*gain   ;计算bias
      filled_img=(1-mask)*(gain*fillimage+bias)+priimage   ;填充

      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,filled_img

      envi_write_envi_file,filled_img,out_name=fileOut,wl=wl
      tmp=dialog_message('Successful!',/info);显示提示框
      ENVI_ENTER_DATA,data,r_fid=fid


      ;window,1
      ;TVSCL,filled_img
      ;window,2
      ;TVSCL,fillimage
    end

    'buttonNext': begin  ;点击next回到on/of界面
      widget_control, ev.top, /destroy
      testWidget
    end
  endcase
end
