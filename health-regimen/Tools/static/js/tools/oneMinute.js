define("js/tools/oneMinute.js", function(require, exports, module) {
    var $ = require("jquery");
    var lib = require("lib");
    var form = require("form");
    var saveLocal = require("js/tools/saveLocal.js?b1cb01de2a12f52b");
    exports.init = init;
    var bmiTpl = function(obj) {
        var __t, __p = "", __j = Array.prototype.join, print = function() {
            __p += __j.call(arguments, "")
        };
        with (obj || {}) {
            __p += '<p class="result-analysis">• 您的身体质量指数(BMI)为<em>' + ((__t = BMI) == null ? "" : __t) + '</em></p>\r\n<table class="result-table">\r\n    <tr>\r\n        <th colspan="2">成年人身体质量指数</th>\r\n    </tr>\r\n    <tr>\r\n        <td>轻体重BMI</td>\r\n        <td>BMI<18.5</td>\r\n    </tr>\r\n    <tr>\r\n        <td>健康体重BMI</td>\r\n        <td>18.5≤BMI<24</td>\r\n    </tr>\r\n    <tr>\r\n        <td>超重BMI</td>\r\n        <td>24≤BMI<28</td>\r\n    </tr>\r\n    <tr>\r\n        <td>肥胖BMI</td>\r\n        <td>28≤BMI</td>\r\n    </tr>\r\n</table>\r\n<p class="result-analysis">• 您的健康体重范围为<em>' + ((__t = w_rate[0]) == null ? "" : __t) + "</em>~<em>" + ((__t = w_rate[1]) == null ? "" : __t) + '</em>公斤</p>\r\n<p class="result-analysis">• 您的年龄身高对应标准体重为<em>' + ((__t = standardWeight) == null ? "" : __t) + '</em>公斤</p>\r\n<p class="result-analysis">• 您的基础代谢率为<em>' + ((__t = BMR) == null ? "" : __t) + '</em>大卡</p>\r\n<p class="result-analysis">• 您的中低强度运动心率是<em>' + ((__t = rate[0]) == null ? "" : __t) + "</em>次/分钟到<em>" + ((__t = rate[1]) == null ? "" : __t) + "</em>次/分钟</p>\r\n";
            if (!hideTip) {
                __p += '\r\n<p class="condition-title">人体要燃烧脂肪，需要满足三个必要条件：</p>\r\n<p class="condition">1、该运动要达到中低强度的运动心率；</p>\r\n<p class="condition">2、这种中低强度运动心率的运动要持续20分钟以上；</p>\r\n<p class="condition">3、这种运动必须是大肌肉群的运动，如慢跑、游泳、健身操等。</p>\r\n<p class="condition-tip">低于或高于这个范围，都不算中低强度运动心率，燃烧的也就不是脂肪了~</p>\r\n'
            }
            __p += "\r\n"
        }
        return __p
    };
    var _hideTip;
    var M = {
        getBMI: function(height, weight) {
            var height = height / 100;
            return (weight / (height * height)).toFixed(1)
        },
        getWeight: function(height, sex) {
            var res;
            if (sex == 1) {
                res = (height - 80) * .7
            } else if (sex == 2) {
                res = (height - 70) * .6
            }
            return res.toFixed(1)
        },
        getBMR: function(height, weight, sex, age) {
            var res;
            if (sex == 1) {
                res = 66 + 13.7 * weight + 5 * height - 6.8 * age
            } else if (sex == 2) {
                res = 655 + 9.6 * weight + 1.8 * height - 4.7 * age
            }
            return res.toFixed(0)
        },
        getRate: function(age) {
            var rate = [];
            rate[0] = ((220 - age - 60) * .6 + 60).toFixed(1);
            rate[1] = ((220 - age - 60) * .8 + 60).toFixed(1);
            return rate
        },
        getWeightRate: function(weight) {
            var w_rate = []
                , pencent = .1;
            w_rate[0] = (weight * (1 - pencent)).toFixed(1);
            w_rate[1] = (weight * (1 + pencent)).toFixed(1);
            return w_rate
        }
    };
    var V = {
        getStandWeight: function() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                weight: M.getWeight(formData.height, formData.gender)
            };
            var tplHmlt = '<p class="result-analysis">• 您的年龄身高对应标准体重为<strong>' + resultData.weight + "</strong>KG（1KG=2斤）</p>";
            saveLocal.formSave("#toolsForm");
            $(".tools-result").html(tplHmlt).show()
        },
        getHealthyWeight: function() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                rage: M.getWeightRate(M.getWeight(formData.height, formData.gender))
            };
            var tplHmlt = '<p class="result-analysis">• 您的健康体重范围为<em>' + resultData.rage[0] + "</em>~<em>" + resultData.rage[1] + "</em>公斤</p>";
            saveLocal.formSave("#toolsForm");
            $(".tools-result").html(tplHmlt).show()
        },
        getBmi: function() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                weight: M.getBMI(formData.height, formData.weight)
            };
            var tplHmlt = '<p class="result-analysis">• 您的身体质量指数(BMI)为<em>' + resultData.weight + "</em></p>";
            saveLocal.formSave("#toolsForm");
            $(".tools-result").html(tplHmlt).show()
        },
        getBmr: function() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                bmr: M.getBMR(formData.height, formData.weight, formData.gender, formData.age)
            };
            var tplHmlt = '<p class="result-analysis">• 您的基础代谢率为<em>' + resultData.bmr + "</em>大卡</p>";
            saveLocal.formSave("#toolsForm");
            $(".tools-result").html(tplHmlt).show()
        },
        getFatBurning: function() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                rage: M.getRate(formData.age)
            };
            var tplHmlt = '<p class="result-analysis">• 您的中低强度运动心率（次/分钟）：<em>' + resultData.rage[0] + "</em> ~ <em>" + resultData.rage[1] + "</em></p>";
            saveLocal.formSave("#toolsForm");
            $(".tools-result").html(tplHmlt).show()
        },
        init: function() {}
    };
    var C = {
        init: function() {
            $("#container").on("click", "#getBMI", function(e) {
                C.handleData();
                return false
            });
            $("#container").on("click", "#getmybmi", function(e) {
                V.getBmi()
            });
            $("#container").on("click", "#getStandardWeight", function(e) {
                V.getStandWeight()
            });
            $("#container").on("click", "#getHealthyWeight", function(e) {
                V.getHealthyWeight()
            });
            $("#container").on("click", "#getbmr", function(e) {
                V.getBmr()
            });
            $("#container").on("click", "#getFatBurning", function(e) {
                V.getFatBurning()
            })
        },
        handleData: function() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!_ts.checkSubmit(formData)) {
                return
            }
            var resultData = {
                BMI: M.getBMI(formData.height, formData.weight),
                BMR: M.getBMR(formData.height, formData.weight, formData.gender, formData.age),
                range: "",
                rate: M.getRate(formData.age),
                w_rate: M.getWeightRate(M.getWeight(formData.height, formData.gender)),
                standardWeight: M.getWeight(formData.height, formData.gender),
                hideTip: _hideTip
            };
            var resultDom = bmiTpl(resultData);
            saveLocal.formSave("#toolsForm");
            $(".tools-result").html(resultDom).show()
        },
        changeLabelName: function(data) {
            $.each(data, function(index, val) {
                if (val == "sex") {
                    data[index] = "性别"
                }
                if (val == "height") {
                    data[index] = "身高"
                }
                if (val == "weight") {
                    data[index] = "体重"
                }
                if (val == "age") {
                    data[index] = "年龄"
                }
            })
        },
        checkDataType: function(data) {
            var type = []
                , reg = /^\d+(\.\d+)*$/;
            $.each(data, function(index, val) {
                if (index == "sex") {
                    return
                }
                if (!reg.test(val)) {
                    type.push(index)
                }
            });
            this.changeLabelName(type);
            if (type.length) {
                var str = "";
                for (var i = 0; i < type.length; i++) {
                    if (i !== 0) {
                        str = str + "、"
                    }
                    str = str + type[i]
                }
                alert("只能在" + str + "填写数字");
                return false
            }
            return true
        },
        checkDataEmpty: function(data) {
            var type = []
                , reg = /^\d+(\.\d+)*$/;
            $.each(data, function(index, val) {
                if (!val) {
                    type.push(index)
                }
            });
            this.changeLabelName(type);
            if (type.length) {
                var str = "";
                for (var i = 0; i < type.length; i++) {
                    if (i !== 0) {
                        str = str + "、"
                    }
                    str = str + type[i]
                }
                alert(str + "不能为空");
                return false
            }
            return true
        },
        checkSubmit: function(data) {
            var _ts = this
                , sign = null;
            if (!_ts.checkDataEmpty(data)) {
                return sign
            }
            if (!_ts.checkDataType(data)) {
                return sign
            }
            sign = true;
            return sign
        }
    };
    C.init();
    function init(hideTip) {
        _hideTip = hideTip;
        saveLocal.formInit("#toolsForm")
    }
});
