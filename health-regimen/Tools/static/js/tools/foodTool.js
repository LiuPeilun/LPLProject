define("js/tools/foodTool.js", function(require, exports, module) {
    var $ = require("jquery");
    var form = require("form");
    var lib = require("lib");
    var dialog = require("dialog");
    var saveLocal = require("js/tools/saveLocal.js?b1cb01de2a12f52b");
    var actDialog;
    function getBMI(height, weight) {
        var height = height / 100;
        return (weight / (height * height)).toFixed(1)
    }
    function getWeightFromBMI(height, bmi) {
        var weight = bmi * (height / 100) * (height / 100);
        return weight
    }
    function getWeight(height, sex) {
        var res;
        if (sex == 1) {
            res = (height - 80) * .7
        } else if (sex == 2) {
            res = (height - 70) * .6
        }
        return res.toFixed(1)
    }
    function calRange() {
        var target = $("select[name='target']").val(), height = $("input[name='height']").val(), curWeight = parseFloat($("input[name='weight']").val()), sugWeight;
        var objTargetWeight = $("input[name='target_weight']");
        if (!curWeight || !target) {
            return
        }
        objTargetWeight.removeAttr("disabled");
        if (target == 1) {
            sugWeight = curWeight * 1.1;
            if (height) {
                var weightBmi1 = getWeightFromBMI(height, 28);
                weightBmi1 = weightBmi1 > curWeight ? weightBmi1 : sugWeight;
                sugWeight = weightBmi1 > sugWeight ? sugWeight : weightBmi1
            }
            sugWeight = curWeight.toFixed(1) + "~" + sugWeight.toFixed(1);
            $("input[name='target_weight']").attr("placeholder", "建议：" + sugWeight).val("")
        } else if (target == 2) {
            sugWeight = curWeight * .85;
            if (height) {
                var weightBmi2 = getWeightFromBMI(height, 18.5);
                weightBmi2 = weightBmi2 < curWeight ? weightBmi2 : sugWeight;
                sugWeight = weightBmi2 < sugWeight ? weightBmi2 : sugWeight
            }
            sugWeight = sugWeight.toFixed(1) + "~" + curWeight.toFixed(1);
            $("input[name='target_weight']").attr("placeholder", "建议：" + sugWeight).val("")
        } else {
            objTargetWeight.attr("disabled", "disabled").val(curWeight)
        }
    }
    function checkRange() {
        var range;
        var $el = $("input[name='target_weight']");
        var userInput = parseFloat($el.val());
        var curWeight = $("input[name='weight']").val();
        var target = parseInt($("select[name='target']").val());
        var tips = "";
        var flag = true;
        $("#bmiTips").hide();
        switch (target) {
            case 1:
                if (curWeight > userInput) {
                    tips = "增肌的目标体重不能低于当前体重";
                    flag = false
                }
                break;
            case 2:
                if (curWeight < userInput) {
                    tips = "减肥的目标体重不能高于当前体重";
                    flag = false
                }
                break
        }
        if (!flag) {
            $("#bmiTips").addClass("error").text(tips).show();
            return false
        }
        return true
    }
    function checkBMI() {
        var height = $("input[name='height']").val();
        var weight = $("input[name='weight']").val();
        var objBmiTips = $("#bmiTips");
        if (!height || height < 100 || !weight || weight < 10) {
            objBmiTips.hide();
            return
        }
        objBmiTips.removeClass("error");
        var BMI = getBMI(height, weight);
        if (BMI < 18.5) {
            objBmiTips.text("当前体重低于健康值，建议选择增肌").show()
        } else if (BMI > 28) {
            objBmiTips.text("当前体重超出健康值，建议选择减肥").show()
        } else {
            objBmiTips.hide()
        }
    }
    function alertActVal(actVal) {
        var checkArr = [actVal == 1.2 ? "checked" : "", actVal == 1.4 ? "checked" : "", actVal == 1.6 ? "checked" : "", actVal == 1.8 ? "checked" : "", actVal == 2 ? "checked" : ""];
        var title = "这个系数是您日常工作、生活和训练的综合系数，请根据描述来选择。";
        var msg = '<div class="dialog-cont">                        <a href="javascript:;" class="btn-close"></a>                        <p class="intro">这个系数是您日常工作、生活和训练的综合系数，请根据描述来选择。</p>                        <ul class="act-list">                                <li data-id="1.2"><label><em>1.2</em><br/>久坐的工作方式，如办公室职员；基本的日常家务；轻微的运动</p><input name="act" type="radio" value="1.2" ' + checkArr[0] + '/></label></li>                                <li data-id="1.4"><label><em>1.4</em><br/><p>工作时有时走动或者站立，如老师；基本的日常家务；每周5-6次每次30分钟中等强度的运动</p><input name="act" type="radio" value="1.4" ' + checkArr[1] + '/></label></li>                                <li data-id="1.6"><label><em>1.6</em><br/><p>工作中经常走动或者站立，如销售员，接待员；基本的日常家务；每周5-6次每次60分钟中等强度的运动或者每周5-6次每次60分钟低强度的抗阻训练</p><input name="act" type="radio" value="1.6" ' + checkArr[2] + '/></label></li>                                <li data-id="1.8"><label><em>1.8</em><br/><p>工作中有较多的体力劳动，如服务员；基本的日常家务；每周5-6次每次有60分钟高强度的运动或者每周5-6次每次60分钟中强度的抗阻训练</p><input name="act" type="radio" value="1.8" ' + checkArr[3] + '/></label></li>                                <li data-id="2.0"><label><em>2.0</em><br/><p>工作中有很大的体力劳动，如建筑工人；基本的日常家务；每周6-7次每次60分钟高强度的运动或者每周6-7次每次60分钟的高强度抗阻训练</p><input name="act" type="radio" value="2.0" ' + checkArr[4] + "/></label></li>                        </ul>                    </div>";
        actDialog = dialog({
            content: msg,
            skin: "foods-dialog",
            autofocus: false
        });
        actDialog.width(window.innerWidth * .9).showModal();
        $(".btn-close").click(function() {
            actDialog.remove()
        });
        $(".act-list li").each(function() {
            var _ts = $(this);
            _ts.click(function() {
                $('input[name="factor"]').val(_ts.attr("data-id"));
                setTimeout(function() {
                    actDialog.remove()
                }, 100)
            })
        })
    }
    var C = {
        init: function(PersonInfo) {
            $("#container").on("click", "#foodtool .submit-bt", function() {
                var fData = form.getFormData("#toolsForm");
                var factor = $(".factor").text();
                if (!fData.age) {
                    lib.showTip("年龄不能为空");
                    return
                }
                if (!fData.height) {
                    lib.showTip("身高不能为空");
                    return
                }
                if (!fData.weight) {
                    lib.showTip("体重不能为空");
                    return
                }
                if (!fData.target_weight) {
                    lib.showTip("请填写目标体重");
                    return
                }
                if (!fData.target) {
                    lib.showTip("请选择目标");
                    return
                }
                if (!fData.factor) {
                    lib.showTip("请选择活动系数");
                    return
                }
                if (!checkRange()) {
                    lib.showTip($("#bmiTips").text());
                    return
                }
                saveLocal.formSave("#toolsForm");
                location.href = "/tools/HealthyFood?age=" + fData.age + "&height=" + fData.height + "&weight=" + fData.weight + "&factor=" + fData.factor + "&target=" + fData.target + "&target_weight=" + fData.target_weight + "&sex=" + fData.gender
            });
            $("#container").on("change", "#foodtool select[name='target']", function() {
                calRange();
                setTimeout(function() {
                    checkRange()
                }, 30)
            });
            $("#container").on("input", "#foodtool input[name='target_weight']", function() {
                checkRange()
            });
            $("#container").on("input", "#foodtool input[name='weight']", function() {
                calRange();
                checkRange();
                checkBMI()
            });
            $("#container").on("input", "#foodtool input[name='height']", function() {
                checkBMI()
            });
            $("#container").on("focus", '#foodtool input[name="factor"]', function() {
                alertActVal($(this).val())
            });
            var sexArr = ["男", "女"];
            var targetArr = ["增肌", "减肥", "塑形"];
            setTimeout(function() {
                var unifo = JSON.parse(localStorage.getItem("unifo")) || {};
                $('#container #foodtool select[name="gender"]').next().text(sexArr[unifo["gender"] - 1]);
                $('#container #foodtool select[name="target"]').next().text(targetArr[unifo["target"] - 1])
            });
            $('#container #foodtool select[name="gender"]').on("change", function() {
                var _ts = $(this);
                setTimeout(function() {
                    _ts.next().text(sexArr[_ts.val() - 1])
                }, 30)
            });
            $('#container #foodtool select[name="target"]').on("change", function() {
                var _ts = $(this);
                _ts.next().text(targetArr[_ts.val() - 1])
            });
            $("#container").on("click", "#foodtool .btn-open", function() {
                var _ts = $(this);
                var introObj = $(".tools-intro");
                if (_ts.hasClass("opened")) {
                    _ts.removeClass("opened");
                    introObj.addClass("close")
                } else {
                    _ts.addClass("opened");
                    introObj.removeClass("close")
                }
            })
        }
    };
    C.init();
    function init() {
        saveLocal.formInit("#container #foodtool #toolsForm");
        calRange();
        checkBMI()
    }
    exports.init = init
});
