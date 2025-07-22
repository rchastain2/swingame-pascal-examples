
demo: demo.pas
	@fpc -Mobjfpc -Sh $< \
	-Fu../swingame/CoreSDK/test \
	-Fu../swingame/CoreSDK/src \
	-Fu../swingame/CoreSDK/libsrc \
	-Fu../swingame/CoreSDK/libsrc/drivers/sdl2 \
	-Fu../swingame/CoreSDK/libsrc/drivers \
	-k-lpng

clean:
	@rm -fv *.o *.ppu demo
