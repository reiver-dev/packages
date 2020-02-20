mkdir build
pushd build

cmake -A x64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=..\dist ..
cmake --build . --config release --target INSTALL

popd

xcopy dist\bin\nvim-qt.exe "%PREFIX%\Library\bin\" /Y
xcopy dist\share\nvim-qt "%PREFIX%\Library\share\nvim-qt\" /Y /S
