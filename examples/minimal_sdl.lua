local ffi = require"ffi"

--from https://github.com/torch/sdl2-ffi
local sdl = require"sdl2"

--just to get gl functions
-- from https://github.com/sonoro1234/LuaJIT-GLFW
local lj_glfw = require"glfw"
local gl, glc, glu, glfw, glext = lj_glfw.libraries()

local ig = require"imgui_sdl"

if (sdl.init(sdl.INIT_VIDEO+sdl.INIT_TIMER) ~= 0) then

        print(string.format("Error: %s\n", sdl.getError()));
        return -1;
end

    sdl.gL_SetAttribute(sdl.GL_CONTEXT_FLAGS, sdl.GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
    sdl.gL_SetAttribute(sdl.GL_CONTEXT_PROFILE_MASK, sdl.GL_CONTEXT_PROFILE_CORE);
    sdl.gL_SetAttribute(sdl.GL_DOUBLEBUFFER, 1);
    sdl.gL_SetAttribute(sdl.GL_DEPTH_SIZE, 24);
    sdl.gL_SetAttribute(sdl.GL_STENCIL_SIZE, 8);
    sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, 3);
    sdl.gL_SetAttribute(sdl.GL_CONTEXT_MINOR_VERSION, 2);
    local current = ffi.new("SDL_DisplayMode[1]")
    sdl.getCurrentDisplayMode(0, current);
    local window = sdl.createWindow("ImGui SDL2+OpenGL3 example", sdl.WINDOWPOS_CENTERED, sdl.WINDOWPOS_CENTERED, 700, 500, sdl.WINDOW_OPENGL+sdl.WINDOW_RESIZABLE); 
    local gl_context = sdl.gL_CreateContext(window);
    sdl.gL_SetSwapInterval(1); -- Enable vsync
    
    -------------------
    ig.lib.Do_gl3wInit()
    ig.CreateContext(nil)
    local igio = ig.GetIO()
    
    ig.lib.ImGui_ImplSDL2_InitForOpenGL(window, gl_context);
    ig.lib.ImGui_ImplOpenGL3_Init(nil);
    
    
    local done = false;
    while (not done) do
        --SDL_Event 
        local event = ffi.new"SDL_Event"
        while (sdl.pollEvent(event) ~=0) do
            ig.lib.ImGui_ImplSDL2_ProcessEvent(event);
            if (event.type == sdl.QUIT) then
                done = true;
            end
            if (event.type == sdl.WINDOWEVENT and event.window.event == sdl.WINDOWEVENT_CLOSE and event.window.windowID == sdl.getWindowID(window)) then
                done = true;
            end
        end
        --standard rendering
        sdl.gL_MakeCurrent(window, gl_context);
        gl.glViewport(0, 0, igio.DisplaySize.x, igio.DisplaySize.y);
        gl.glClear(glc.GL_COLOR_BUFFER_BIT)
        -- Start the ImGui frame
        ig.lib.ImGui_ImplOpenGL3_NewFrame();
        ig.lib.ImGui_ImplSDL2_NewFrame(window);
        ig.lib.igNewFrame();
        
        
        if ig.Button"Hello" then
            print"Hello World!!"
        end
        ig.ShowDemoWindow(showdemo)
        
        ig.lib.igRender();
        ig.lib.ImGui_ImplOpenGL3_RenderDrawData(ig.lib.igGetDrawData());
        sdl.gL_SwapWindow(window);
    end
    
    -- Cleanup
    ig.lib.ImGui_ImplOpenGL3_Shutdown();
    ig.lib.ImGui_ImplSDL2_Shutdown();
    ig.DestroyContext();

    sdl.gL_DeleteContext(gl_context);
    sdl.destroyWindow(window);
    sdl.quit();

