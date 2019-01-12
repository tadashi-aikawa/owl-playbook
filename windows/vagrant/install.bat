@FOR /F "usebackq delims=:" %%t IN (`cat %~dp0packages.config ^| xargs`) DO call vagrant plugin install %%t
