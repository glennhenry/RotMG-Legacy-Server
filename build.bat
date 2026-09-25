@echo off
echo Building server JAR...
call gradlew.bat shadowJar
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Gradle build failed!
    pause
    exit /b 1
)

echo "Build finished."
echo.


set /p BUILDDOCS=Build documentation website? (y/n): 

if /i "%BUILDDOCS%"=="y" (
    echo.
    echo Building documentation...
    pushd docs

    if exist package.json (
        call npm install
        if %errorlevel% neq 0 (
            echo [ERROR] npm install failed!
            popd
            pause
            exit /b 1
        )
    )

    call npm run build
    if %errorlevel% neq 0 (
        echo [ERROR] npm build failed!
        popd
        pause
        exit /b 1
    )

    echo Moving built docs to deploy/docs_build/ ...
    popd

    if not exist deploy mkdir deploy
    if exist deploy\docs_build rmdir /s /q deploy\docs_build
    mkdir deploy\docs_build

    xcopy /e /i /y "docs\dist" "deploy\docs_build" >nul

    echo Documentation successfully moved to deploy/docs_build/
) else (
    echo Skipping documentation build.
)

echo.
echo =====================================
echo Build finished successfully!
echo Press any key to exit...
pause >nul
