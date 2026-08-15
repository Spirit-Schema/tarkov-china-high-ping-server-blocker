# Third-party notices

The `ExcludeChinaHighPingServer.exe` and
`ExcludeChinaHighPingServer_Delete.exe` programs use Microsoft Windows and
.NET Framework platform APIs. They do not bundle a third-party software
library. Microsoft platform components remain subject to Microsoft's terms.

The optional `TarkovServerPingChecker-v0.3.0.zip` companion asset has the
following separate notices. These notices are preserved independently of the
project's Tarkov Server Guard Source-Available Freeware License 1.0.

## EFT: Where Am I

- Repository: https://github.com/karpitony/eft-where-am-i
- Files consulted: `UserControls/ServerLocation.cs`, `Classes/SettingsHandler.cs`
- License: MIT
- Copyright: Copyright (c) 2024 karpitony, Copyright (c) 2026 supnoel

The referenced project detects the last server address from EFT
`*application*.log` files using an `Ip:` log pattern and locates the EFT log
directory through installation metadata and common paths. Tarkov Server Ping
Checker reimplements those ideas in a smaller standalone application and
retains this attribution.

```text
MIT License

Copyright (c) 2024 karpitony
Copyright (c) 2026 supnoel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## IPWhois.io

- Service: https://ipwho.is/
- Documentation: https://ipwhois.io/documentation

When the user requests a location lookup, Tarkov Server Ping Checker sends
each unique detected game-server IP to the IPWhois.io HTTPS endpoint. EFT log
contents and local paths are not included in that request.
