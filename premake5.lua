solution "SEAPI"
    configurations { "Debug", "Release" }
    platforms { "x86", "x64" }
    location "build"
    characterset "MBCS" 
    symbols "On"
    defines {"_CRT_SECURE_NO_DEPRECATE" }
    objdir "obj/%{prj.name}/%{cfg.buildcfg}%{cfg.platform}"
    targetdir "bin/%{cfg.buildcfg}%{cfg.platform}"
    startproject "IntelSEAPI"
   
    filter "platforms:x86"
        architecture "x86"

    filter "platforms:x64"
        architecture "x86_64"
        
    project "ittnotify"
        location "build"
        kind "StaticLib"
        includedirs {
            "ittnotify/include",
        }
        files {
            "ittnotify/src/ittnotify/*.c",
            "ittnotify/src/ittnotify/*.h",
        }
        filter "platforms:x86"
            targetname "ittnotify32"
        filter "platforms:x64"
            targetname "ittnotify64"
    
    project "sea_itt_lib"
        location "build"
        kind "SharedLib"
        links {"ittnotify"}
        includedirs {
            "sea_itt_lib",
            "ittnotify/include",
            "ittnotify"
        }
        files {
            "sea_itt_lib/sea_itt_lib.cpp",
            "sea_itt_lib/IttNotifyStdSrc.cpp",
            "sea_itt_lib/IttNotifyStdSrc.h",
            "sea_itt_lib/Recorder.cpp",
            "sea_itt_lib/Recorder.h",
            "sea_itt_lib/TraceEventFormat.h",
            "sea_itt_lib/Utils.cpp",
            "sea_itt_lib/Utils.h",
        }
        filter "platforms:x86"
            targetname "IntelSEAPI32"
        filter "platforms:x64"
            targetname "IntelSEAPI64"
    
        filter "system:windows"
            includedirs {
                "%{cfg.objdir}"
            }
            files {
                "sea_itt_lib/IntelSEAPI.man",
                "sea_itt_lib/ETWHandler.cpp",
                "sea_itt_lib/ETLRelogger.cpp",
                "%{cfg.objdir}/IntelSEAPI.h",
                "%{cfg.objdir}/IntelSEAPI.rc"
            }
            links {
                "ws2_32",
                "Shlwapi",
                "Dbghelp",
            }
            
            filter { "files:sea_itt_lib/IntelSEAPI.man" }
                buildmessage "Generating %{cfg.objdir}/IntelSEAPI.rc %{cfg.objdir}/IntelSEAPI.h"
                buildcommands {
                    'mc -um %{file.relpath} -h %{cfg.objdir} -r %{cfg.objdir}'
                }
                buildoutputs { "%{cfg.objdir}/IntelSEAPI.h" }
                
    project "IntelSEAPI"
        location "build"
        kind "ConsoleApp"
        includedirs {
            "ittnotify/include",
        }
        files {
            "main.cpp",
            "memory.cpp",
            "InstrumentationExample.cpp",
            "CompilerAutomatedInstrumentation.cpp",
            "itt_notify.hpp",
        }
        links {
            "sea_itt_lib", "ittnotify"
        }
        
        