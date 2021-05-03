pro FVC
  tlb=widget_base($                                                                 
    xsize=830,$
    ysize=400,$
    title='Calculate FVC')                                      

  base1=widget_base($
  tlb,$
  xsize=365,$
  ysize=350,$
  frame=1,$
  xoffset=25,$
  yoffset=25)
  
  base2=widget_base($
  tlb,$
  xsize=415,$
  ysize=300,$
  frame=1,$
  xoffset=400,$
  yoffset=25)
  
  draw1=widget_draw($
  base1,$
  xsize=345,$
  ysize=340,$
  xoffset=10,$
  yoffset=5)


  lab=widget_label($
  base2,$
  value='Open File',$
  xoffset=10,$
  yoffset=20)
  
  lab1=widget_label($
  base2,$
  value='Choos Output File',$
  xoffset=10,$
  yoffset=100)

  openfile=widget_text($
  base2,$
  xsize=38,$
  ysize=1,$
  xoffset=5,$
  yoffset=40,$
  uname='textin')
  
  outfile=widget_text($
  base2,$
  xsize=38,$
  ysize=1,$
  xoffset=5,$
  yoffset=120,$
  uname='textout')

  openfile=widget_button($
  base2,$
  value='Open',$
  xsize=70,$
  ysize=25,$
  xoffset=340,$
  yoffset=40,$
  uname='openfile')
  
  openoutputfile=widget_button($
  base2,$
  value='Choose',$
  xsize=70,$
  ysize=25,$
  xoffset=340,$
  yoffset=120,$
  uname='openoutputfile')
  
  run=widget_button($
  base2,$
  value='Run',$
  xsize=70,$
  ysize=25,$
  xoffset=340,$
  yoffset=250,$
  uname='run')
  
   widget_control,tlb,/realize 
   widget_control,draw1,get_value=win
   widget_control,tlb,set_uvalue=win
   xmanager,'fvc',tlb,/no_block
end

pro fvc_event,e
compile_opt idl2
  widget_control,e.top,get_uvalue=win
  uname=widget_info(e.id,/uname)
 
  textin=widget_info(e.top,find_by_uname='textin')
  textout=widget_info(e.top,find_by_uname='textout')
  case uname of
    'openfile':begin
      envi,/restore_base_save_files
      envi_batch_init
      file=dialog_pickfile()
      widget_control,textin,set_value=file
      envi_open_file,file,r_fid=fid
      if(fid eq -1) then return
      ENVI_FILE_QUERY,fid,DIMS=dims, NB=nb,ns=ns,nl=nl,wl=wl
      data=uintarr(ns,nl,nb)
      for  i=0,nb-1 do begin
        img=envi_get_data(fid=fid,dims=dims,pos=i)
        data[*,*,i]=img
        image=data[*,*,[3,2,1]]
        image=congrid(image,350,340,3)
        widget_control,e.top,get_uvalue=win
        wset,win
        tvscl,image,true=3
      endfor
    end
    'openoutputfile':begin
      fileout=dialog_pickfile(/write)
      widget_control,textout,set_value=fileout
    end



    'run':begin
      widget_control,textin,get_value=file
      widget_control,textout,get_value=fileout
      envi,/restore_base_save_files
      envi_batch_init
      envi_open_file,file,r_fid=fid
      ENVI_FILE_QUERY, fid, DIMS=dims, nb=nb,ns=ns,nl=nl,wl=wl
      data=uintarr(ns,nl,nb)
      for  i=0,nb-1 do begin
        img=envi_get_data(fid=fid,dims=dims,pos=i)
        data[*,*,i]=img
      endfor
      ndvi=(data[*,*,3]-data[*,*,2])*1.0/(data[*,*,3]+data[*,*,2])
      print,ndvi[1:5,1:5]
      ndvi=(ndvi gt 1)*1+(ndvi lt -1)*(-1)+(ndvi le 1 and ndvi ge -1)*ndvi
      ndvisort=ndvi[sort(ndvi)]
      n=n_elements(ndvi)
      n5=long(n*0.05)
      n95=long(n*0.95)
      ndvis=ndvisort[n5]
      ndviv=ndvisort[n95]
      fvc=(ndvi-ndvis)/(ndviv-ndvis)
      fvc=(fvc gt 1)*1+(fvc lt 0)*0+(fvc le 1 and fvc ge 0)*fvc
      print,fvc[1:10,1:10]
      widget_control,e.top,get_uvalue=win
      wset,win
      tvscl,fvc
      envi_write_envi_file,fvc,out_name=fileout,wl=wl
      tmp=dialog_message('successful',/info)
    end
  endcase
end

