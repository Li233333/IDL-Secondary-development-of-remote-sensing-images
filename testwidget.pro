pro testWidget
  forward_function ENVI_FILE_QUERY
  tlb=widget_base(xsize=850,ysize=500,title='on/off',tlb_frame_attr=1) ;创建容器并设置大小及名称
  widget_control,tlb,/realize
  base1=widget_base(tlb,xsize=200,ysize=200,frame=1,xoffset=10,yoffset=5)  ;将控件添加至base1，并设置相应参数
  base2=widget_base(tlb,xsize=700,ysize=500,xoffset=40,yoffset=250)  ;将控件添加至base2，并设置相应参数
  base3=widget_base(tlb,xsize=200,ysize=200,frame=1,xoffset=210,yoffset=5) ;将控件添加至base3，并设置相应参数
  base4=widget_base(tlb,xsize=200,ysize=200,frame=1,xoffset=410,yoffset=5) ;将控件添加至base4，并设置相应参数
  base5=widget_base(tlb,xsize=200,ysize=200,frame=1,xoffset=600,yoffset=5) ;将控件添加至base5，并设置相应参数
  draw1=widget_draw(base1,xsize=200,ysize=200,xoffset=0,yoffset=0,uname='draw1') ;创建图像显示控件，并设置相应参数
  widget_control,draw1,get_value=win1  ;获取图像控件的窗口ID
  widget_control,tlb,set_uvalue=win1   ;保存图像控件的窗口ID
  draw3=widget_draw(base3,xsize=200,ysize=200,xoffset=0,yoffset=0,uname='draw3');容器中添加图象显示控件，并设置相应参数
  widget_control,draw3,get_value=win2 ;获取图像控件的窗口ID
  widget_control,tlb,set_uvalue=win2   ;保存图像控件的窗口ID
  draw4=widget_draw(base4,xsize=200,ysize=200,xoffset=0,yoffset=0,uname='draw4');容器中添加图象显示控件，并设置相应参数
  widget_control,draw4,get_value=win3 ;获取图像控件的窗口ID 
  widget_control,tlb,set_uvalue=win3  ;保存图像控件的窗口ID
  draw5=widget_draw(base5,xsize=200,ysize=200,xoffset=0,yoffset=0,uname='draw5');容器中添加图象显示控件，并设置相应参数
  widget_control,draw5,get_value=win4 ;获取图像控件的窗口ID
  widget_control,tlb,set_uvalue=win4  ;保存图像控件的窗口ID
  lab=widget_label(base2,value='Open Mask File',xoffset=10,yoffset=15) ;创建文字控件，添加至Base2,设置位置
  lab=widget_label(base2,value='Open Input have destrip File',xoffset=10,yoffset=70) ;创建文字控件，添加至Base2,设置位置
  lab=widget_label(base2,value='Open Input no destrip File',xoffset=10,yoffset=125);创建文字控件，添加至Base2,设置位置
  lab=widget_label(base2,value='Open Output File',xoffset=10,yoffset=180);创建文字控件，添加至Base2,设置位置
  ;建立文本文件
  maskfile=widget_text(base2,xsize=55,ysize=1,xoffset=5,yoffset=30,uname='textmask')
  imagefile=widget_text(base2,xsize=55,ysize=1,xoffset=5,yoffset=85,uname='textin')
  metedatafile=widget_text(base2,xsize=55,ysize=1,xoffset=5,yoffset=140,uname='textinmetedata')
  outfile=widget_text(base2,xsize=55,ysize=1,xoffset=5,yoffset=195,uname='textout')
  ;建立控制按钮
  openmask=widget_button(base2,value='open',xsize=70,ysize=25,xoffset=400,yoffset=30,uname='openmask')
  openimage=widget_button(base2,value='open',xsize=70,ysize=25,xoffset=400,yoffset=85,uname='openimage')
  opendatafile=widget_button(base2,value='open',xsize=70,ysize=25,xoffset=400,yoffset=140,uname='opendatafile')
  openoutputfile=widget_button(base2,value='open',xsize=70,ysize=25,xoffset=400,yoffset=195,uname='openoutputfile')
  run=widget_button(base2,value='run',xsize=70,ysize=25,xoffset=500,yoffset=195,uname='run')
  next=widget_button(base2,value='next',xsize=70,ysize=25,xoffset=600,yoffset=195,uname='next')
  xmanager,'testWidget',tlb,/no_block
  
end
pro testWidget_event,e ;定义事件响应函数
  uname=widget_info(e.id,/uname);获取触发事件的控件的uname
  widget_control,e.top,get_uvalue=win1
  widget_control,e.top,get_uvalue=win2
  widget_control,e.top,get_uvalue=win3
  widget_control,e.top,get_uvalue=win4
  draw1=widget_info(e.top,find_by_uname='draw1')
  draw3=widget_info(e.top,find_by_uname='draw3')
  draw4=widget_info(e.top,find_by_uname='draw4')
  draw5=widget_info(e.top,find_by_uname='draw5')
  textmask=widget_info(e.top,find_by_uname='textmask')
  textin=widget_info(e.top,find_by_uname='textin')
  textinmetedata=widget_info(e.top,find_by_uname='textinmetedata')
  textout=widget_info(e.top,find_by_uname='textout')
  case uname of
    ;影像文件的打开和保存核心代码
     'openmask':begin  ;点击openmask开始以下操作
        envi,/restore_base_save_files
       envi_batch_init ;批处理
       file=dialog_pickfile(/read)
       widget_control,textmask,set_value=file
       envi_open_file,file,r_fid=fid
       if(fid eq -1) then return
       ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
       data=uintarr(ns,nl,nb);创建三维数组，并执行以下操作
       for  i=0,nb-1 do begin
         img=envi_get_data(fid=fid,dims=dims,pos=i)
         data[*,*,i]=img
         image=data[*,*,[4,3,2]];以4，3，2颜色显示图像
         image=congrid(image,350,340,3);调整图像大小
         widget_control,draw5,get_value=win4
         wset,win4
         tvscl,image,true=3  ;显示图像
       endfor
     end
    'openimage':begin  ;点击openimage开始以下操作
      envi,/restore_base_save_files
      envi_batch_init ;批处理
      file=dialog_pickfile(/read)
      widget_control,textin,set_value=file
      envi_open_file,file,r_fid=fid
      if(fid eq -1) then return
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
      data=uintarr(ns,nl,nb);创建三维数组，并执行以下操作
      for  i=0,nb-1 do begin
        img=envi_get_data(fid=fid,dims=dims,pos=i)
        data[*,*,i]=img 
        image=data[*,*,[4,3,2]];以4，3，2颜色显示图像
        image=congrid(image,350,340,3);调整图像大小
        widget_control,draw1,get_value=win2
        wset,win2
        tvscl,image,true=3  ;显示图像
      endfor
    end
    'opendatafile':begin ;点击opendatafile开始以下操作
      envi,/restore_base_save_files
      envi_batch_init
      file=dialog_pickfile()
      widget_control,textinmetedata,set_value=file
      envi_open_file,file,r_fid=fid
      if(fid eq -1) then return
      ENVI_FILE_QUERY, fid, DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
      data=uintarr(ns,nl,nb)
      for  i=0,nb-1 do begin
        img=envi_get_data(fid=fid,dims=dims,pos=i)
        data[*,*,i]=img
        image=data[*,*,[4,3,2]]
        image=congrid(image,350,340,3);调整图像大小
        widget_control,draw3,get_value=win3
        wset,win3
        tvscl,image,true=3;显示图像
      endfor
    end

   'openoutputfile':begin ;点击openoutputfile开始以下操作
      fileout=dialog_pickfile(/write)
      widget_control,textout,set_value=fileout
    end
    'run':begin ;点击run开始以下操作
      widget_control,textmask,get_value=file2
      widget_control,textin,get_value=file
      widget_control,textinmetedata,get_value=file1
      widget_control,textout,get_value=fileout
      COMPILE_OPT idl2

      ENVI,  /restore_base_save_file
      ENVI_Batch_Init
       ;打开slc on影像
      ENVI_OPEN_FILE,file,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      pos=indgen(nb)
      priimage=uintarr(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        priimage[*,*,i]=temp
      ENDFOR
      ;打开slc off影像
      ENVI_OPEN_FILE,file1,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      pos=INDGEN(nb)
      fillimage=UINTARR(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        fillimage[*,*,i]=temp
      ENDFOR

      ;用0定义mask
      sized=SIZE(priimage,/N_DIMENSIONS )
      IF  sized EQ 2 then begin
        temp=priimage
      ENDIF ELSE BEGIN
        temp=reform(priimage[*,*,0],ns,nl);调整图像
      ENDELSE

      mask=~(~temp)
      ;第一阶段参数
      para_n=140
      para_win=17
      para_winmax=31
      ;测试算法
      tol=0.01
      gain=1
      bias=0
      x1=SIZE(mask,/dimensions)
      x2=SIZE(priimage,/dimensions)
      x3=SIZE(fillimage,/dimensions)
      ;剔除高饱和度的数据 排除条带区域
      imask=REFORM(mask, x1[0]*x1[1])
      ind1=WHERE(imask NE 0)
      ipri_image = congrid(priimage, x2[0],x2[1])
      ifill_imag = congrid(fillimage, x3[0],x3[1])
      ;求出增益与偏执
      mup=MEAN(ipri_image[ind1]);求部分缺失图像均值
      muf=MEAN(ifill_imag[ind1]);求缺失图像均值
      thetap=VARIANCE(ipri_image[ind1]);求缺失图像方差
      thetaf=VARIANCE(ifill_imag[ind1])
      gain=thetap/thetaf  ;计算gain
      if gain>3||gain<1/3 then gain=1
      bias=mup-muf*gain ;计算bias,y=gain*x+b
      filled_img=(1-mask)*(gain*fillimage+bias)+priimage ;填充图像
      widget_control,draw4,get_value=g
      wset,g
      tvscl,filled_img ;显示图像

      tmp=dialog_message('successful',/info)  ;successful对话框
    end
    'next':begin  ;点击next执行以下操作
      widget_control,textout,get_value=fileout
      ENVI,/restore_base_save_file
      ENVI_Batch_Init
      widget_control,textIn,get_value=file 
      ENVI_OPEN_FILE,file,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      pos=indgen(nb)
      pri_image=uintarr(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        pri_image[*,*,i]=temp
      ENDFOR
      widget_control,textinmetedata,get_value=file1
      ENVI_OPEN_FILE,file1,R_FID=fid
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
      pos=INDGEN(nb)
      fill_image=UINTARR(ns,nl,nb)
      FOR i=0,nb-1 DO BEGIN
        temp1=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        fill_image[*,*,i]=temp1
      ENDFOR
      ;define the mask by zeros
      sized=SIZE(pri_image,/N_DIMENSIONS )
      IF  sized EQ 2 then begin
        temp=pri_image
      ENDIF ELSE BEGIN

        temp=reform(pri_image[*,*,0],ns,nl)
      ENDELSE

      mask=~(~temp)
      ;parameter for phase one
      para_n=140
      para_win=17
      para_winmax=31
     ;test the algorithm
      minw=floor(para_win/2)
      maxw=floor(para_winmax/2)
      padpri_img =  REPLICATE(0,ns+maxw*2,nl+maxw*2)
      padpri_img[15,15]=pri_image
      padfill_imag =  REPLICATE(0,ns+maxw*2,nl+maxw*2)
      padfill_imag[15,15]=fill_image
      padmask_imag = REPLICATE(0,ns+maxw*2,nl+maxw*2)
      padmask_imag[15,15]=mask
      result=size(padpri_img, /dimensions)
      w=minw
      
      
      for i=maxw,(result[0]-maxw-1) do begin
        for j=maxw,(result[1]-maxw-1) do begin
          w=minw
          if padmask_imag[i,j] ge 0 then begin
            ;取出局部窗口区域数据
            imask=padmask_imag[i-w:i+w,j-w:j+w]
            nzeros=where(imask ne 0);判断掩模板文件
            while ~(size(nzeros,/n_elements) gt para_n)&&w lt maxw do begin;判断窗口内的非0像元数满足要求否？
              w=w+1
              imask=padmask_imag[i-w:i+w,j-w:j+w]
              nzeros=where(imask ne 0)
            endwhile
            ;也暂不考虑适合的适合的像元总数最后仍然不满足要求的情况
            ;若不满足则用全局增益与偏置？
            limg=padpri_img[i-w:i+w,j-w:j+w]
            lfill=padfill_imag[i-w:i+w,j-w:j+w]
            ;暂不考虑高饱和度像元去除，可以通过提取出来后的图像中剔除
            gain=VARIANCE(limg[nzeros])/ VARIANCE(lfill[nzeros])
            if gain gt 3 or gain lt 1/3 then gain=1
            bias=mean(limg[nzeros])-gain*mean(lfill[nzeros])
            pri_image[i-maxw,j-maxw]=fill_image[i-maxw,j-maxw]*gain+bias
          endif
        endfor
      endfor


      envi_write_envi_file,pri_image,out_name=fileout
      ;display[*,*]=congrid(reform(pri_image[*,*]),280,340)
      widget_control,e.top,get_uvalue=d
      wset,d

      TVSCL,  pri_image
      tmp=dialog_message('successful',/info);弹出successful对话框0
    end
  endcase
end
