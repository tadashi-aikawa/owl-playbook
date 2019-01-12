@FOR /F "usebackq delims=:" %%t IN (`cat %~dp0packages.config ^| xargs`) DO call scoop install %%t
