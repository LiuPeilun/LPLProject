define("task",function(require,exports,module){var lib=require("lib");var M={taskAccess:function(user_id,task_id){var url="/activity/taskAccess";var param={user_id:user_id,task_id:task_id};lib.post(url,param)}};var C={init:function(){var user_id=lib.getParam("user_id");var task_id=lib.getParam("task_id");if(user_id&&task_id){M.taskAccess(user_id,task_id)}}};C.init()});