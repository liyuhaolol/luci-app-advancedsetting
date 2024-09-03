#-- Copyright (C) 2018 dz <dingzhong110@gmail.com>
local fs = require "nixio.fs"
local sys = require "luci.sys"
m = Map("advancedsetting", translate("高级设置"), translate("各类服务内置脚本文档的直接编辑,除非你知道自己在干什么,否则请不要轻易修改这些配置文档"))
s = m:section(TypedSection, "advancedsetting")
s.anonymous=true
--dnsmasq
if nixio.fs.access("/etc/dnsmasq.conf") then
s:tab("config1", translate("dnsmasq"),translate("本页是配置/etc/dnsmasq.conf的文档内容。应用保存后重启生效"))
conf = s:taboption("config1", Value, "editconf1", nil, translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template = "cbi/tvalue"
conf.rows = 20
conf.wrap = "off"
function conf.cfgvalue(self, section)
    return fs.readfile("/etc/dnsmasq.conf") or ""
end
function conf.write(self, section, value)
    if value then
        value = value:gsub("\r\n?", "\n")
        fs.writefile("/tmp/dnsmasq.conf", value)
        if (luci.sys.call("cmp -s /tmp/dnsmasq.conf /etc/dnsmasq.conf") == 1) then
            fs.writefile("/etc/dnsmasq.conf", value)
            luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
        end
        fs.remove("/tmp/dnsmasq.conf")
    end
end
end
--network
if nixio.fs.access("/etc/config/network") then
s:tab("config2", translate("network"),translate("本页是配置/etc/config/network的文档内容。"))
conf = s:taboption("config2", Value, "editconf2", nil, translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template = "cbi/tvalue"
conf.rows = 20
conf.wrap = "off"
function conf.cfgvalue(self, section)
    return fs.readfile("/etc/config/network") or ""
end
function conf.write(self, section, value)
    if value then
        value = value:gsub("\r\n?", "\n")
        fs.writefile("/tmp/netwok", value)
        if (luci.sys.call("cmp -s /tmp/network /etc/config/network") == 1) then
            fs.writefile("/etc/config/network", value)
            luci.sys.call("/etc/init.d/network restart >/dev/null")
        end
        fs.remove("/tmp/network")
    end
end
end

--hosts
if nixio.fs.access("/etc/hosts") then
s:tab("config3", translate("hosts"),translate("本页是配置/etc/hosts的文档内容。"))
conf = s:taboption("config3", Value, "editconf3", nil, translate("开头的数字符号（＃）或分号的每一行（;）被视为注释；删除（;）启用指定选项。"))
conf.template = "cbi/tvalue"
conf.rows = 20
conf.wrap = "off"
function conf.cfgvalue(self, section)
    return fs.readfile("/etc/hosts") or ""
end
function conf.write(self, section, value)
    if value then
        value = value:gsub("\r\n?", "\n")
        fs.writefile("/tmp/etc/hosts", value)
        if (luci.sys.call("cmp -s /tmp/etc/hosts /etc/hosts") == 1) then
            fs.writefile("/etc/hosts", value)
            luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
        end
        fs.remove("/tmp/etc/hosts")
    end
end
end

return m
