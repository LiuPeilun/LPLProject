define("js/tools/saveLocal.js", function (require, exports, module) {
    var $ = require("jquery");
    var sdk = require("hidySdk");
    exports.formInit = formInit;
    exports.formSave = formSave;

    function formInit(selector, fn) {
        if (!window.localStorage) {
            return
        }
        try {
            var unifo = JSON.parse(localStorage.getItem("unifo"));
            if (!unifo) {
                unifo = {}
            }
            setTimeout(function () {
                HiydSdk.getUserInfo(function (data) {
                    if (!data) {
                        return
                    }
                    for (var i in data) {
                        unifo[i] = data[i];
                        if (i == "birthday") {
                            var curDate = new Date;
                            var birthDate = new Date(data[i]);
                            unifo["age"] = curDate.getFullYear() - birthDate.getFullYear()
                        }
                    }
                    localStorage.setItem("unifo", JSON.stringify(unifo))
                })
            }, 500);
            setTimeout(function () {
                var $input = $(selector).find("input, select, textarea");
                unifo = JSON.parse(localStorage.getItem("unifo"));
                for (var i = 0; i < $input.length; i++) {
                    var $this = $($input[i]);
                    var key = $input[i].name || $input[i].id;
                    if (unifo && unifo.hasOwnProperty(key)) {
                        var localKey = unifo[key];
                        if (key) {
                            var type = $this.attr("type");
                            if (type == "radio" && localKey) {
                                $('input[name="' + key + '"][value="' + localKey + '"]').prop("checked", true)
                            } else if (type != "submit" && type != "button" && localKey) {
                                if (/^\d*\.\d*$/.test(localKey)) {
                                    console.log(localKey);
                                    $this.val(parseFloat(localKey).toFixed(1))
                                } else {
                                    $this.val(localKey)
                                }
                            }
                        }
                    }
                }
                if (fn) {
                    fn()
                }
            }, 600)
        } catch (e) {
        }
    }

    function formSave(selector) {
        if (!window.localStorage) {
            return
        }
        try {
            var unifo = JSON.parse(localStorage.getItem("unifo"));
            var $input = $(selector).find("input, select, textarea");
            if (!unifo) {
                unifo = {}
            }
            for (var i = 0; i < $input.length; i++) {
                var $this = $($input[i]);
                var key = $input[i].name || $input[i].id;
                if (key) {
                    var type = $this.attr("type");
                    if (type == "radio") {
                        unifo[key] = $("input[name=" + key + "]:checked").val()
                    } else if (type != "submit" && type != "button") {
                        unifo[key] = $this.val()
                    }
                }
            }
            localStorage.setItem("unifo", JSON.stringify(unifo))
        } catch (e) {
        }
    }
});