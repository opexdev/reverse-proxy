local allowed_ext = {".png", ".jpg", ".jpeg", ".svg"}
local blocked_ext = {".php", ".exe", ".sh", ".bat", ".js", ".html", ".htm"}

local function normalize_name(value)
    if type(value) ~= "string" then
        return ""
    end
    return value:gsub("^%s+", ""):gsub("%s+$", "")
end

local function ends_with(str, ending)
    str = normalize_name(str)
    ending = normalize_name(ending)
    if str == "" or ending == "" then
        return false
    end
    return str:lower():sub(-#ending) == ending:lower()
end

local function contains_blocked(str)
    str = normalize_name(str):lower()
    for _, ext in ipairs(blocked_ext) do
        if str:find(ext, 1, true) then
            return true
        end
    end
    return false
end

local headers = ngx.req.get_headers()
local content_type = headers["content-type"]
local admin_ips = {
    ["188.136.193.194"] = true,
    ["193.186.32.236"] = true,
    ["188.75.66.34"] = true,
}
local client_ip = ngx.var.remote_addr
local is_admin = admin_ips[client_ip] or false

ngx.log(
    ngx.ERR,
    "URI=", ngx.var.request_uri,
    " METHOD=", ngx.req.get_method(),
    " CONTENT_TYPE=", tostring(content_type),
    " ADMIN=", tostring(is_admin)
)

if content_type and content_type:find("multipart/form-data", 1, true) then
    ngx.req.read_body()
    local body = ngx.req.get_body_data()
    if body then
        for filename in body:gmatch('filename="(.-)"') do
            filename = normalize_name(filename)
            if filename == "" then
                ngx.status = 400
                ngx.say("Blocked upload: empty file part")
                ngx.log(ngx.ERR, "Blocked upload: empty file part")
                ngx.exit(400)
            end

            local allowed = false
            for _, ext in ipairs(allowed_ext) do
                if ends_with(filename, ext) then
                    allowed = true
                    break
                end
            end

            if not allowed then
                ngx.status = 403
                ngx.say("Blocked upload: unsupported file type")
                ngx.log(ngx.ERR, "Blocked upload: unsupported file type for filename=", filename)
                ngx.exit(403)
            end

            if contains_blocked(filename) then
                ngx.status = 403
                ngx.say("Blocked upload: filename contains forbidden extension")
                ngx.log(ngx.ERR, "Blocked upload: filename contains forbidden extension: ", filename)
                ngx.exit(403)
            end

            if filename:lower():match("%.svg$") and not is_admin then
                ngx.status = 403
                ngx.say("Blocked upload: SVG upload allowed for admins only")
                ngx.log(ngx.ERR, "Blocked upload: SVG upload allowed for admins only")
                ngx.exit(403)
            end
        end
    end
end
