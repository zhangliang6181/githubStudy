<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="testHtml_test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../JS/jquery-1.9.1.js"></script>
    <script src="bootstrap-paginator.js"></script>
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <script>
        //var options = {
        //    currentPage: 1,
        //    size: "normal",
        //    bootstrapMajorVersion: 3,
        //    alignment: "center",
        //    numberOfPages: 10,
        //    totalPages: 1, //总页数

        //    itemTexts: function (type, page, current) {
        //        switch (type) {
        //            case "first": return "首页";
        //            case "prev": return "上一页";
        //            case "next": return "下一页";
        //            case "last": return "末页";
        //            case "page": return page;
        //        }
        //    },
        //    onPageClicked: function (event, originalEvent, type, page) {
        //        alert(page);
        //    }
        //};
        //$(document).ready(function () {
        //    $("#pagination").bootstrapPaginator(options);
        //});

        var commonFn = {};
        //paginatorSelector选择器，option{currentPage: 当前是第几页, pageSize:每页显示多少条,onPageClicked:点击页码的事件}
        commonFn.setAjaxPaginator = function (paginatorSelector, option) {
            var totals = option.dataCount;//总条数
            var pageSize = option.pageSize; //每页显示多少条数据
            var totalPages = 1;
            if (totals != 0) {
                if (totals % pageSize == 0) {
                    totalPages = totals / pageSize;
                } else {
                    totalPages = Math.ceil(totals / pageSize);
                }
            }

            if (totalPages > 1) {
                //当总页数大于1时生成显示分页否则不显示分页
                //commonFn.buildAjaxPaginator(paginatorSelector, $.extend(option, { totalPages: totalPages }))
                option.totalPages = totalPages;
                commonFn.buildAjaxPaginator(paginatorSelector, option)
            }
        }

        commonFn.buildAjaxPaginator = function (paginatorSelector, option) {
            var _option = {
                //currentPage: 1, //当前页
                //totalPages: 1, //总页数
                //numberOfPages: 10, //设置控件显示的页码数
                currentPage: option.currentPage, //当前页
                totalPages: option.totalPages, //总页数
                numberOfPages: option.pageSize, //设置控件显示的页码数
                onPageClicked: option.onPageClicked,
                bootstrapMajorVersion: 3,//如果是bootstrap3版本需要加此标识，并且设置包含分页内容的DOM元素为UL,如果是bootstrap2版本，则DOM包含元素是DIV
                useBootstrapTooltip: false,//是否显示tip提示框
                
                itemTexts: function (type, page, current) {//文字翻译
                    switch (type) {
                        case "first":
                            return "首页";
                        case "prev":
                            return "上一页";
                        case "next":
                            return "下一页";
                        case "last":
                            return "尾页";
                        case "page":
                            return page;
                    }
                }
            };
            //$.extend(_option, option);
            paginatorSelector.bootstrapPaginator(_option);
        }


        //JS
        //点击查询按钮进行查询
        $(function () {
            $('.btn').click(function () {
                queryOperate(1, 10)
            })
        })

        var defaultPagination = { "page": 1, "pageSize": 10 }; //默认配置的当前页和每页显示条数

        //重写点击分页执行的方法 传递当前点击的页面
        function onPageClick(event, originalEvent, type, page) { //点击分页插件时传递的当前页和每页显示条数
            queryOperate(page, defaultPagination.pageSize);
        };

        //查询操作
        function queryOperate(page, pageSize) {
            var queryData = { "FL": "ZLBT" };//其他的表单提交值

            $.extend(queryData, { page: page || 1, pageSize: pageSize || 10 });//提交查询操作的参数
            $.ajax({
                type: "Post",
                dataType: "JSON",
                data: queryData,
                url: "/admin/BTBZ.ashx?act=btselect",
                success: function (res) {
                    console.log(res);
                    var option = {};
                    option.currentPage = queryData.page;
                    option.pageSize = queryData.pageSize;
                    option.onPageClicked = onPageClick;
                    option.dataCount = 101;/*假设总条数100*/
                    //var data = { count: 101 }
                    //生成分页
                    commonFn.setAjaxPaginator($('.page'), option);

                    //DOM操作显示装载的数据内容

                    $('.loadPageDataSelector').html(res.data[0].BZ + queryData.page)
                },

                complete: function (data) {

                }
            })
        }
    </script>

</head>
<body>
    <form id="formTest" runat="server">
        <span class="btn">查询</span>
        <div class="pagination">
            <ul class="page"></ul>
        </div>
        <div class="loadPageDataSelector"></div>
    </form>
</body>
</html>
