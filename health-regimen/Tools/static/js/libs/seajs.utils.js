(function (global, undefined) {
    if (global.seajs) {
        return
    }
    var seajs = global.seajs = {version: "2.3.0"};
    var data = seajs.data = {};

    function isType(type) {
        return function (obj) {
            return {}.toString.call(obj) == "[object " + type + "]"
        }
    }

    var isObject = isType("Object");
    var isString = isType("String");
    var isArray = Array.isArray || isType("Array");
    var isFunction = isType("Function");
    var _cid = 0;

    function cid() {
        return _cid++
    }

    var events = data.events = {};
    seajs.on = function (name, callback) {
        var list = events[name] || (events[name] = []);
        list.push(callback);
        return seajs
    };
    seajs.off = function (name, callback) {
        if (!(name || callback)) {
            events = data.events = {};
            return seajs
        }
        var list = events[name];
        if (list) {
            if (callback) {
                for (var i = list.length - 1; i >= 0; i--) {
                    if (list[i] === callback) {
                        list.splice(i, 1)
                    }
                }
            } else {
                delete events[name]
            }
        }
        return seajs
    };
    var emit = seajs.emit = function (name, data) {
        var list = events[name], fn;
        if (list) {
            list = list.slice();
            for (var i = 0, len = list.length; i < len; i++) {
                list[i](data)
            }
        }
        return seajs
    };
    var DIRNAME_RE = /[^?#]*\//;
    var DOT_RE = /\/\.\//g;
    var DOUBLE_DOT_RE = /\/[^\/]+\/\.\.\//;
    var MULTI_SLASH_RE = /([^:\/])\/+\//g;

    function dirname(path) {
        return path.match(DIRNAME_RE)[0]
    }

    function realpath(path) {
        path = path.replace(DOT_RE, "/");
        path = path.replace(MULTI_SLASH_RE, "$1/");
        while (path.match(DOUBLE_DOT_RE)) {
            path = path.replace(DOUBLE_DOT_RE, "/")
        }
        return path
    }

    function normalize(path) {
        var last = path.length - 1;
        var lastC = path.charAt(last);
        if (lastC === "#") {
            return path.substring(0, last)
        }
        return path.substring(last - 2) === ".js" || path.indexOf("?") > 0 || lastC === "/" ? path : path + ".js"
    }

    var PATHS_RE = /^([^\/:]+)(\/.+)$/;
    var VARS_RE = /{([^{]+)}/g;

    function parseAlias(id) {
        var alias = data.alias;
        return alias && isString(alias[id]) ? alias[id] : id
    }

    function parsePaths(id) {
        var paths = data.paths;
        var m;
        if (paths && (m = id.match(PATHS_RE)) && isString(paths[m[1]])) {
            id = paths[m[1]] + m[2]
        }
        return id
    }

    function parseVars(id) {
        var vars = data.vars;
        if (vars && id.indexOf("{") > -1) {
            id = id.replace(VARS_RE, function (m, key) {
                return isString(vars[key]) ? vars[key] : m
            })
        }
        return id
    }

    function parseMap(uri) {
        var map = data.map;
        var ret = uri;
        if (map) {
            for (var i = 0, len = map.length; i < len; i++) {
                var rule = map[i];
                ret = isFunction(rule) ? rule(uri) || uri : uri.replace(rule[0], rule[1]);
                if (ret !== uri) break
            }
        }
        return ret
    }

    var ABSOLUTE_RE = /^\/\/.|:\//;
    var ROOT_DIR_RE = /^.*?\/\/.*?\//;

    function addBase(id, refUri) {
        var ret;
        var first = id.charAt(0);
        // console.log(id);
        // console.log(111111);
        // console.log(first);
        // console.log(222222);
        // console.log(data.cwd);
        if (ABSOLUTE_RE.test(id)) {
            ret = id
        } else if (first === ".") {
            ret = realpath((refUri ? dirname(refUri) : data.cwd) + id)
        // } else if (first === "/") {
        //     var m = data.cwd.match(ROOT_DIR_RE);
        //     ret = m ? m[0] + id.substring(1) : id
        } else {
            // ret = data.base + id
            //     var n = data.cwd.match(ROOT_DIR_RE);
            // console.log(n);
            var m = data.cwd.match(ROOT_DIR_RE);
            // ret = m ? m[0] + id.substring(1) : id
            ret = data.cwd + "static/" + id
        }
        if (ret.indexOf("//") === 0) {
            ret = location.protocol + ret
        }
        // console.log(4444);
        // console.log(ret)
        return ret
    }

    function id2Uri(id, refUri) {
        if (!id) return "";
        id = parseAlias(id);
        id = parsePaths(id);
        id = parseVars(id);
        id = normalize(id);
        var uri = addBase(id, refUri);
        uri = parseMap(uri);
        return uri
    }

    var doc = document;
    var cwd = !location.href || location.href.indexOf("about:") === 0 ? "" : dirname(location.href);
    var scripts = doc.scripts;
    var loaderScript = doc.getElementById("seajsnode") || scripts[scripts.length - 1];
    var loaderDir = dirname(getScriptAbsoluteSrc(loaderScript) || cwd);

    function getScriptAbsoluteSrc(node) {
        return node.hasAttribute ? node.src : node.getAttribute("src", 4)
    }

    seajs.resolve = id2Uri;
    var head = doc.head || doc.getElementsByTagName("head")[0] || doc.documentElement;
    var baseElement = head.getElementsByTagName("base")[0];
    var currentlyAddingScript;
    var interactiveScript;

    function request(url, callback, charset) {
        var node = doc.createElement("script");
        if (charset) {
            var cs = isFunction(charset) ? charset(url) : charset;
            if (cs) {
                node.charset = cs
            }
        }
        addOnload(node, callback, url);
        node.async = true;
        node.src = url;
        currentlyAddingScript = node;
        baseElement ? head.insertBefore(node, baseElement) : head.appendChild(node);
        currentlyAddingScript = null
    }

    function addOnload(node, callback, url) {
        var supportOnload = "onload" in node;
        if (supportOnload) {
            node.onload = onload;
            node.onerror = function () {
                emit("error", {uri: url, node: node});
                onload()
            }
        } else {
            node.onreadystatechange = function () {
                if (/loaded|complete/.test(node.readyState)) {
                    onload()
                }
            }
        }

        function onload() {
            node.onload = node.onerror = node.onreadystatechange = null;
            if (!data.debug) {
                head.removeChild(node)
            }
            node = null;
            callback()
        }
    }

    function getCurrentScript() {
        if (currentlyAddingScript) {
            return currentlyAddingScript
        }
        if (interactiveScript && interactiveScript.readyState === "interactive") {
            return interactiveScript
        }
        var scripts = head.getElementsByTagName("script");
        for (var i = scripts.length - 1; i >= 0; i--) {
            var script = scripts[i];
            if (script.readyState === "interactive") {
                interactiveScript = script;
                return interactiveScript
            }
        }
    }

    seajs.request = request;
    var REQUIRE_RE = /"(?:\\"|[^"])*"|'(?:\\'|[^'])*'|\/\*[\S\s]*?\*\/|\/(?:\\\/|[^\/\r\n])+\/(?=[^\/])|\/\/.*|\.\s*require|(?:^|[^$])\brequire\s*\(\s*(["'])(.+?)\1\s*\)/g;
    var SLASH_RE = /\\\\/g;

    function parseDependencies(code) {
        var ret = [];
        code.replace(SLASH_RE, "").replace(REQUIRE_RE, function (m, m1, m2) {
            if (m2) {
                ret.push(m2)
            }
        });
        return ret
    }

    var cachedMods = seajs.cache = {};
    var anonymousMeta;
    var fetchingList = {};
    var fetchedList = {};
    var callbackList = {};
    var STATUS = Module.STATUS = {FETCHING: 1, SAVED: 2, LOADING: 3, LOADED: 4, EXECUTING: 5, EXECUTED: 6};

    function Module(uri, deps) {
        this.uri = uri;
        this.dependencies = deps || [];
        this.exports = null;
        this.status = 0;
        this._waitings = {};
        this._remain = 0
    }

    Module.prototype.resolve = function () {
        var mod = this;
        var ids = mod.dependencies;
        var uris = [];
        for (var i = 0, len = ids.length; i < len; i++) {
            uris[i] = Module.resolve(ids[i], mod.uri)
        }
        return uris
    };
    Module.prototype.load = function () {
        var mod = this;
        if (mod.status >= STATUS.LOADING) {
            return
        }
        mod.status = STATUS.LOADING;
        var uris = mod.resolve();
        emit("load", uris);
        var len = mod._remain = uris.length;
        var m;
        for (var i = 0; i < len; i++) {
            m = Module.get(uris[i]);
            if (m.status < STATUS.LOADED) {
                m._waitings[mod.uri] = (m._waitings[mod.uri] || 0) + 1
            } else {
                mod._remain--
            }
        }
        if (mod._remain === 0) {
            mod.onload();
            return
        }
        var requestCache = {};
        for (i = 0; i < len; i++) {
            m = Module.get2(uris[i]);
            if (m.status < STATUS.FETCHING) {
                m.fetch(requestCache)
            } else if (m.status === STATUS.SAVED) {
                m.load()
            }
        }
        for (var requestUri in requestCache) {
            if (requestCache.hasOwnProperty(requestUri)) {
                requestCache[requestUri]()
            }
        }
    };
    Module.prototype.onload = function () {
        var mod = this;
        mod.status = STATUS.LOADED;
        if (mod.callback) {
            mod.callback()
        }
        var waitings = mod._waitings;
        var uri, m;
        for (uri in waitings) {
            if (waitings.hasOwnProperty(uri)) {
                m = Module.get(uri);
                m._remain -= waitings[uri];
                if (m._remain === 0) {
                    m.onload()
                }
            }
        }
        delete mod._waitings;
        delete mod._remain
    };
    Module.prototype.fetch = function (requestCache) {
        var mod = this;
        var uri = mod.uri;
        mod.status = STATUS.FETCHING;
        var emitData = {uri: uri};
        emit("fetch", emitData);
        var requestUri = emitData.requestUri || uri;
        if (!requestUri || fetchedList[requestUri]) {
            mod.load();
            return
        }
        if (fetchingList[requestUri]) {
            callbackList[requestUri].push(mod);
            return
        }
        fetchingList[requestUri] = true;
        callbackList[requestUri] = [mod];
        emit("request", emitData = {uri: uri, requestUri: requestUri, onRequest: onRequest, charset: data.charset});
        if (!emitData.requested) {
            requestCache ? requestCache[emitData.requestUri] = sendRequest : sendRequest()
        }

        function sendRequest() {
            seajs.request(emitData.requestUri, emitData.onRequest, emitData.charset)
        }

        function onRequest() {
            delete fetchingList[requestUri];
            fetchedList[requestUri] = true;
            if (anonymousMeta) {
                Module.save(uri, anonymousMeta);
                anonymousMeta = null
            }
            var m, mods = callbackList[requestUri];
            delete callbackList[requestUri];
            while (m = mods.shift()) m.load()
        }
    };
    Module.prototype.exec = function () {
        var mod = this;
        if (mod.status >= STATUS.EXECUTING) {
            return mod.exports
        }
        mod.status = STATUS.EXECUTING;
        var uri = mod.uri;

        function require(id) {
            return Module.get(require.resolve(id)).exec()
        }

        require.resolve = function (id) {
            return Module.resolve(id, uri)
        };
        require.async = function (ids, callback) {
            var uri2 = uri.split("?")[0];
            Module.use(ids, callback, uri2 + "_async_" + cid());
            return require
        };
        var factory = mod.factory;
        var exports = isFunction(factory) ? factory(require, mod.exports = {}, mod) : factory;
        if (exports === undefined) {
            exports = mod.exports
        }
        delete mod.factory;
        mod.exports = exports;
        mod.status = STATUS.EXECUTED;
        emit("exec", mod);
        return exports
    };
    Module.resolve = function (id, refUri) {
        var emitData = {id: id, refUri: refUri};
        emit("resolve", emitData);
        return emitData.uri || seajs.resolve(emitData.id, refUri)
    };
    Module.define = function (id, deps, factory) {
        var argsLen = arguments.length;
        if (argsLen === 1) {
            factory = id;
            id = undefined
        } else if (argsLen === 2) {
            factory = deps;
            if (isArray(id)) {
                deps = id;
                id = undefined
            } else {
                deps = undefined
            }
        }
        if (!isArray(deps) && isFunction(factory)) {
            deps = parseDependencies(factory.toString())
        }
        var meta = {id: id, uri: Module.resolve(id), deps: deps, factory: factory};
        if (!meta.uri && doc.attachEvent) {
            var script = getCurrentScript();
            if (script) {
                meta.uri = script.src
            }
        }
        emit("define", meta);
        meta.uri ? Module.save(meta.uri, meta) : anonymousMeta = meta
    };
    Module.save = function (uri, meta) {
        var mod = Module.get(uri);
        if (mod.status < STATUS.SAVED) {
            mod.id = meta.id || uri;
            mod.dependencies = meta.deps || [];
            mod.factory = meta.factory;
            mod.status = STATUS.SAVED;
            emit("save", mod)
        }
    };
    Module.get = function (uri, deps) {
        var uri2 = uri.split("?")[0];
        return cachedMods[uri2] || (cachedMods[uri2] = new Module(uri, deps))
    };
    Module.get2 = function (uri, deps) {
        uri = uri.split("?")[0];
        return cachedMods[uri]
    };
    Module.use = function (ids, callback, uri) {
        var mod = Module.get(uri, isArray(ids) ? ids : [ids]);
        mod.callback = function () {
            var exports = [];
            var uris = mod.resolve();
            for (var i = 0, len = uris.length; i < len; i++) {
                exports[i] = Module.get2(uris[i]).exec()
            }
            if (callback) {
                callback.apply(global, exports)
            }
            delete mod.callback
        };
        mod.load()
    };
    seajs.use = function (ids, callback) {
        Module.use(ids, callback, data.cwd + "_use_" + cid());
        return seajs
    };
    Module.define.cmd = {};
    global.define = Module.define;
    seajs.Module = Module;
    data.fetchedList = fetchedList;
    data.cid = cid;
    seajs.require = function (id) {
        var mod = Module.get(Module.resolve(id));
        if (mod.status < STATUS.EXECUTING) {
            mod.onload();
            mod.exec()
        }
        return mod.exports
    };
    data.base = loaderDir;
    data.dir = loaderDir;
    data.cwd = cwd;
    data.charset = "utf-8";
    seajs.config = function (configData) {
        for (var key in configData) {
            var curr = configData[key];
            var prev = data[key];
            if (prev && isObject(prev)) {
                for (var k in curr) {
                    prev[k] = curr[k]
                }
            } else {
                if (isArray(prev)) {
                    curr = prev.concat(curr)
                } else if (key === "base") {
                    if (curr.slice(-1) !== "/") {
                        curr += "/"
                    }
                     curr = addBase(curr)
                }
                data[key] = curr
            }
        }
        emit("config", configData);
        return seajs
    };
    var Module = seajs.Module;
    var FETCHING = Module.STATUS.FETCHING;
    var data = seajs.data;
    var comboHash = data.comboHash = {};
    var comboSyntax = ["_s/??", ","];
    var comboMaxLength = 2e3;
    var comboExcludes;
    var comboSuffix;
    if (window.BDY && !BDY.debug) {
        seajs.on("load", setComboHash);
        seajs.on("fetch", setRequestUri)
    }

    function setComboHash(uris) {
        var len = uris.length;
        if (len < 2) {
            return
        }
        data.comboSyntax && (comboSyntax = data.comboSyntax);
        data.comboMaxLength && (comboMaxLength = data.comboMaxLength);
        data.comboSuffix && (comboSuffix = data.comboSuffix);
        comboExcludes = data.comboExcludes;
        var needComboUris = [];
        for (var i = 0; i < len; i++) {
            var uri = uris[i];
            if (comboHash[uri]) {
                continue
            }
            var mod = Module.get(uri);
            if (mod.status < FETCHING && !isExcluded(uri) && !isComboUri(uri)) {
                needComboUris.push(uri)
            }
        }
        if (needComboUris.length > 1) {
            paths2hash(uris2paths(needComboUris))
        }
    }

    function setRequestUri(data) {
        data.requestUri = comboHash[data.uri] || data.uri
    }

    function uris2paths(uris) {
        return meta2paths(uris2meta(uris))
    }

    function uris2meta(uris) {
        var meta = {__KEYS: []};
        for (var i = 0, len = uris.length; i < len; i++) {
            var parts = uris[i].replace("://", "__").split("/");
            var m = meta;
            for (var j = 0, l = parts.length; j < l; j++) {
                var part = parts[j];
                if (!m[part]) {
                    m[part] = {__KEYS: []};
                    m.__KEYS.push(part)
                }
                m = m[part]
            }
        }
        return meta
    }

    function meta2paths(meta) {
        var paths = [];
        var __KEYS = meta.__KEYS;
        for (var i = 0, len = __KEYS.length; i < len; i++) {
            var part = __KEYS[i];
            var root = part;
            var m = meta[part];
            var KEYS = m.__KEYS;
            if (KEYS.length) {
                paths.push([root.replace("__", "://"), meta2arr(m)])
            }
        }
        return paths
    }

    function meta2arr(meta) {
        var arr = [];
        var __KEYS = meta.__KEYS;
        for (var i = 0, len = __KEYS.length; i < len; i++) {
            var key = __KEYS[i];
            var r = meta2arr(meta[key]);
            var m = r.length;
            if (m) {
                for (var j = 0; j < m; j++) {
                    arr.push(key + "/" + r[j])
                }
            } else {
                arr.push(key)
            }
        }
        return arr
    }

    function paths2hash(paths) {
        for (var i = 0, len = paths.length; i < len; i++) {
            var path = paths[i];
            var root = path[0] + "/";
            var group = files2group(path[1]);
            for (var j = 0, m = group.length; j < m; j++) {
                setHash(root, group[j])
            }
        }
        return comboHash
    }

    function setHash(root, files) {
        var copy = [];
        for (var i = 0, len = files.length; i < len; i++) {
            copy[i] = files[i]
        }
        var comboPath = root + comboSyntax[0] + copy.join(comboSyntax[1]);
        if (comboSuffix) {
            comboPath += comboSuffix
        }
        var exceedMax = comboPath.length > comboMaxLength;
        if (files.length > 1 && exceedMax) {
            var parts = splitFiles(files, comboMaxLength - (root + comboSyntax[0]).length);
            setHash(root, parts[0]);
            setHash(root, parts[1])
        } else {
            if (exceedMax) {
                throw new Error("The combo url is too long: " + comboPath)
            }
            for (var i = 0, len = files.length; i < len; i++) {
                comboHash[root + files[i]] = comboPath
            }
        }
    }

    function splitFiles(files, filesMaxLength) {
        var sep = comboSyntax[1];
        var s = files[0];
        for (var i = 1, len = files.length; i < len; i++) {
            s += sep + files[i];
            if (s.length > filesMaxLength) {
                return [files.splice(0, i), files]
            }
        }
    }

    function files2group(files) {
        var group = [];
        var hash = {};
        for (var i = 0, len = files.length; i < len; i++) {
            var file = files[i];
            var ext = getExt(file);
            if (ext) {
                (hash[ext] || (hash[ext] = [])).push(file)
            }
        }
        for (var k in hash) {
            if (hash.hasOwnProperty(k)) {
                group.push(hash[k])
            }
        }
        return group
    }

    function getExt(file) {
        var p = file.match(/.+\.(js|css)[?#]*.*$/);
        return p && p.length >= 2 ? p[1] : ""
    }

    function isExcluded(uri) {
        if (comboExcludes) {
            return comboExcludes.test ? comboExcludes.test(uri) : comboExcludes(uri)
        }
    }

    function isComboUri(uri) {
        var comboSyntax = data.comboSyntax || ["??", ","];
        var s1 = comboSyntax[0];
        var s2 = comboSyntax[1];
        return s1 && uri.indexOf(s1) > 0 || s2 && uri.indexOf(s2) > 0
    }
})(this);
if (typeof JSON !== "object") {
    JSON = {}
}
(function () {
    "use strict";

    function f(n) {
        return n < 10 ? "0" + n : n
    }

    if (typeof Date.prototype.toJSON !== "function") {
        Date.prototype.toJSON = function () {
            return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null
        };
        String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function () {
            return this.valueOf()
        }
    }
    var cx, escapable, gap, indent, meta, rep;

    function quote(string) {
        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === "string" ? c : "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)
        }) + '"' : '"' + string + '"'
    }

    function str(key, holder) {
        var i, k, v, length, mind = gap, partial, value = holder[key];
        if (value && typeof value === "object" && typeof value.toJSON === "function") {
            value = value.toJSON(key)
        }
        if (typeof rep === "function") {
            value = rep.call(holder, key, value)
        }
        switch (typeof value) {
            case"string":
                return quote(value);
            case"number":
                return isFinite(value) ? String(value) : "null";
            case"boolean":
            case"null":
                return String(value);
            case"object":
                if (!value) {
                    return "null"
                }
                gap += indent;
                partial = [];
                if (Object.prototype.toString.apply(value) === "[object Array]") {
                    length = value.length;
                    for (i = 0; i < length; i += 1) {
                        partial[i] = str(i, value) || "null"
                    }
                    v = partial.length === 0 ? "[]" : gap ? "[\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "]" : "[" + partial.join(",") + "]";
                    gap = mind;
                    return v
                }
                if (rep && typeof rep === "object") {
                    length = rep.length;
                    for (i = 0; i < length; i += 1) {
                        if (typeof rep[i] === "string") {
                            k = rep[i];
                            v = str(k, value);
                            if (v) {
                                partial.push(quote(k) + (gap ? ": " : ":") + v)
                            }
                        }
                    }
                } else {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = str(k, value);
                            if (v) {
                                partial.push(quote(k) + (gap ? ": " : ":") + v)
                            }
                        }
                    }
                }
                v = partial.length === 0 ? "{}" : gap ? "{\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "}" : "{" + partial.join(",") + "}";
                gap = mind;
                return v
        }
    }

    if (typeof JSON.stringify !== "function") {
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
        meta = {"\b": "\\b", "	": "\\t", "\n": "\\n", "\f": "\\f", "\r": "\\r", '"': '\\"', "\\": "\\\\"};
        JSON.stringify = function (value, replacer, space) {
            var i;
            gap = "";
            indent = "";
            if (typeof space === "number") {
                for (i = 0; i < space; i += 1) {
                    indent += " "
                }
            } else if (typeof space === "string") {
                indent = space
            }
            rep = replacer;
            if (replacer && typeof replacer !== "function" && (typeof replacer !== "object" || typeof replacer.length !== "number")) {
                throw new Error("JSON.stringify")
            }
            return str("", {"": value})
        }
    }
    if (typeof JSON.parse !== "function") {
        cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
        JSON.parse = function (text, reviver) {
            var j;

            function walk(holder, key) {
                var k, v, value = holder[key];
                if (value && typeof value === "object") {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v
                            } else {
                                delete value[k]
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value)
            }

            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)
                })
            }
            if (/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) {
                j = eval("(" + text + ")");
                return typeof reviver === "function" ? walk({"": j}, "") : j
            }
            throw new SyntaxError("JSON.parse")
        }
    }
})();
seajs.importCss = function (url) {
    var flag = false;
    var links = document.getElementsByTagName("link");
    for (var i = 0; i < links.length; i++) {
        if (links[i].href.indexOf(url) >= 0) {
            flag = true
        }
    }
    if (!flag) {
        var link = document.createElement("link");
        link.rel = "stylesheet";
        link.type = "text/css";
        link.href = url;
        document.getElementsByTagName("head")[0].appendChild(link)
    }
};
var SITE_URL = "/";
window.BDY = window.BDY || {};
if ("createTouch" in document) {
    BDY.click = "click";
    BDY.touchstart = "touchstart";
    BDY.touchmove = "touchmove";
    BDY.touchend = "touchend";
    BDY.longTap = "longTap"
} else {
    BDY.click = "click";
    BDY.touchstart = "mousedown";
    BDY.touchmove = "mousemove";
    BDY.touchend = "mouseup";
    BDY.longTap = "hover"
}
BDY.url = SITE_URL;
BDY.appId = 4;
if (/test\.|webdev.ouj.com/.test(document.location.href)) {
    localStorage.setItem("env", "test");
    BDY.debug = true;
    // BDY.userUrl = "http://test.user.api.oxzj.net/"
} else if (/new\./.test(document.location.href)) {
    localStorage.setItem("env", "new");
    BDY.debug = false;
    // BDY.userUrl = "http://user.api.oxzj.net/"
} else {
    localStorage.setItem("env", "product");
    BDY.debug = false;
    // BDY.userUrl = "http://user.api.ouj.com/"
}
BDY.pageChange = "pageChange";
BDY.navBtnClick = "navBtnClick";
seajs.config({
    alias: {
        jquery: "js/libs/jq2.js?9e81e2c1195f6c6e",
        $: "js/libs/jq2.js?9e81e2c1195f6c6e",
        tpl: "js/libs/template.js?527c149c6fb9a899",
        dialog: "js/libs/dialog.js?dc1d8992521b037c",
        treeTable: "js/libs/treeTable/jquery.treeTable.js?25ff5024fdc5621c",
        cookie: "js/libs/cookie.js?fe7d21303720fb26",
        store: "js/libs/store.js?dac566520185e9d6",
        form: "js/libs/form.js?dad3ed37fa481541",
        template: "js/libs/template.js?527c149c6fb9a899",
        lib: "js/libs/library.js?0ca1e40e32bf293b",
        md5: "js/libs/md5.js?c503fdff9f5536a2",
        lazyr: "js/libs/lazyr.js?dae7e64366757ff1",
        swipe: "js/libs/swipe.js?5d4ae09e4f956931",
        react: "js/libs/react.js?0a0380bb45052efb",
        nprogress: "js/libs/nprogress.js?92aa9dd422d11791",
        underscore: "js/libs/underscore.js?475a15881d6b4ecd",
        swiper: "js/libs/idangerous.swiper.js?bc998f6c8cfbe11a",
        hidySdk: "js/libs/ext-sdk.js?46f33bc3a8d7ca0b",
        task: "js/libs/task.js?de03b49d6fc1b774",
        clndr: "js/libs/clndr.js?f37641bb35fda3e0",
        logiMRApi: "js/libs/logiMRApi.js?ead33270263160b2",
        weixin: "js/libs/jweixin-1.0.0.js?b7e86f061c0770ba"
    }, debug: BDY.debug, base: "static/", charset: "utf-8", timeout: 2e4
});
BDY.defalutPageInfo = {title: "", allowGuest: false, allowBack: true, noTopBar: false, navBtn: null};
BDY.params = [];
BDY.timeout = [];
BDY.interval = [];
