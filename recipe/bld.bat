setlocal EnableDelayedExpansion
@echo on

set "MESON=%BUILD_PREFIX%\Scripts\meson.exe"

if not exist "%MESON%" (
  set "MESON=%BUILD_PREFIX%\python.exe %BUILD_PREFIX%\Scripts\meson-script.py"
)

:: meson options
:: (set pkg_config_path so deps in host env can be found)
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  --wrap-mode=nofallback ^
  --buildtype=release ^
  --backend=ninja ^
  -D docs=false ^
 ^"

:: configure build using meson
%MESON% setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

:: print results of build configuration
%MESON% configure builddir
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1
