PROG := demo

$(PROG): $(PROG).pas
	@fpc -Mobjfpc -Sh $< \
	-Fu../swingame/CoreSDK/test \
	-Fu../swingame/CoreSDK/src \
	-Fu../swingame/CoreSDK/libsrc \
	-Fu../swingame/CoreSDK/libsrc/drivers/sdl2 \
	-Fu../swingame/CoreSDK/libsrc/drivers \
	-Fujosephusproblem \
	-k-lpng

clean:
	@rm -fv *.o *.ppu josephusproblem/*.o josephusproblem/*.ppu $(PROG)
