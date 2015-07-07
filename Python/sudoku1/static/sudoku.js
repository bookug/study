/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var level = location.search;
var gamelevel = level.charAt(5);




$.log = function(msg) {
    console.log(msg);
}

$(
        function() {
            [{number: 1, bgcolor: "#C71585"}, {number: 2, bgcolor: "#800080"}, {number: 3, bgcolor: "#B8110B"},
                {number: 4, bgcolor: "rgb(0,0,128)"}, {number: 5, bgcolor: "rgb(30,144,255)"},
                {number: 6, bgcolor: "rgb(255,165,0)"},
                {number: 7, bgcolor: "hsl(0,75%,50%)"}, {number: 8, bgcolor: "hsl(30,50%,50%)"},
                {number: 9, bgcolor: "hsl(120,75%,38%)"}].forEach(
                    function(key, index) {
                        //$.log(key);
                        var li = $("<li>").html(key.number).css("backgroundColor", key.bgcolor).attr("draggable", "true");
                        //$.log(li);
                        li[0].addEventListener("dragstart", function(e) {
                            e.dataTransfer.effectAllowed = "copyMove";
                            e.dataTransfer.setData("text/plain", this.innerHTML);
                            $.log(this.innerHTML);
                            [].forEach.call(document.querySelectorAll("#player .default"),
                                    function(item) {
                                        //$.log(item);
                                        item.classList.remove("default");
                                        item.classList.add("ation");
                                    });
                        }, false);

                        li[0].addEventListener("dragend", function() {
                            [].forEach.call(document.querySelectorAll("#player .ation"),
                                    function(item) {
                                        item.classList.remove("ation");
                                        item.classList.add("default");
                                    });
                        }, false);

                        $("#numberBox").append(li);
                    }
            );
        }
);
var timeIndex = 0;
var timer;
$(
        function() {
            //var l=$("#gamelevel").val();
            //if(l<1||l>64){
            //  alert("请选择正确的挖空值（1-64)!");
            // return;
            // }
            $("#player").css("background", "#FFA500");
            $("#player").empty();
            $("#divTime").empty();
            timeIndex = 0;//初始化timeIndex
            clearInterval(timer);//初始化timer
            setTime();
            timer = setInterval(setTime, 1000);
            InitData(gamelevel).split("").forEach(
                    function(item, index) {
                        $.log(item);
                        var li = $("<li>")
                        if (item != "0") {
                            li.addClass("fix");
                            li[0].innerHTML = item;
                        }
                        else {
                            li[0].classList.add("default");
                            li[0].addEventListener("dragenter",
                                    function(e) {
                                        $.log(e);
                                    }, false);

                            li[0].addEventListener("dragover",
                                    function(e) {
                                        if (e.preventDefault) {
                                            e.preventDefault(); //不要执行与事件关联的默认动作
                                        }
                                        if (e.stopPropagation) {
                                            e.stopPropagation(); //停止事件的传播
                                        }
                                        $.log(e);
                                        return false;
                                    }, false);

                            li[0].addEventListener("dragleave",
                                    function(e) {
                                    }, false);

                            li[0].addEventListener("drop",
                                    function(e) {
                                        if (e.preventDefault) {
                                            e.preventDefault(); //不要执行与事件关联的默认动作
                                        }
                                        if (e.stopPropagation) {
                                            e.stopPropagation(); //停止事件的传播
                                        }

                                        var sendData = e.dataTransfer.getData("text/plain");
                                        //获得#player>li矩阵数组
                                        var matrix = Array.prototype.slice.call(document.querySelectorAll("#player>li"));
                                        var currIndex = matrix.indexOf(this); //获得当前元素的位置
                                        var rowIndex = currIndex - currIndex % 9; //行开始的位置
                                        var colIndex = currIndex % 9//列开始的位置
                                        for (var i = rowIndex; i < rowIndex + 9; i++) {
                                            if (i != currIndex && matrix[i].innerHTML == sendData) {
                                                alert("对不起行上有数据重复，请小心哦！亲");
                                                return;
                                            }
                                        }
                                        for (var i = colIndex; i < 81; i = i + 9) {
                                            if (i != currIndex && matrix[i].innerHTML == sendData) {
                                                alert("对不起列上有数据重复，请小心哦！亲");
                                                return;
                                            }
                                        }

                                        this.innerHTML = sendData;

                                        // bin add 胜利检查
                                        for (var i = 0; i < 81; i = i + 1)
                                        {
                                            if (matrix[i].innerHTML == 0)
                                            {
                                                return;
                                            }
                                        }
                                        finishAndSubmit();


                                    }, false);
                        }
                        $("#player").append(li);
                    }
            );
        }
);

function finishAndSubmit()
{
    window.clearInterval(timer);
    var text = "胜利！您的成绩是：" + timeIndex + "秒。请问是否提交成绩？"
    if (confirm(text))
    {
        var name = prompt("请输入您的名称：", "");
        if (name)
        {
            $.post("/add_record/", {name:name, time:timeIndex},
              function(data){
                var dataObj=eval("("+data+")");
                if(dataObj.state == "1")
                {
                    if(dataObj.total_rank)
                    {
                  alert("提交成功,您在本地的排名为: " + dataObj.local_rank+"\n" + "您在总英雄榜的排名为: " + dataObj.total_rank);
                    }
                
                else
                {

                    alert("提交成功,您在本地的排名为: " + dataObj.local_rank);
                }
                }
              });
        }
        else
        {
            alert("由于您没有输入名称，成绩不作提交。");
        }
    }
    else
    {
        alert("如果想重新再来，请刷新网页。");
    }

}

function InitData(l)
{
    function SwapRow()
    {
        var bigindex = Math.floor(Math.random() * 3), index = Math.floor(Math.random() * 3), RowA = bigindex * 3 + index, RowB = bigindex * 3 + (index + 1) % 3;
        var temp = s[RowA];
        s[RowA] = s[RowB];
        s[RowB] = temp;
    }

    function SwapCol()
    {
        var bigindex = Math.floor(Math.random() * 3), index = Math.floor(Math.random() * 3), ColA = bigindex * 3 + index, ColB = bigindex * 3 + (index + 1) % 3, temp = 0;
        for (li = 0; li < 9; li++)
        {
            temp = s[ColA][li];
            s[ColA][li] = s[ColB][li];
            s[ColB][li] = temp;
        }
    }

    function SwapBigRow()
    {
        var bigindex = Math.floor(Math.random() * 3), RowA = bigindex, RowB = (bigindex + 1) % 3;
        SwapRow(RowA * 3, RowB * 3);
        SwapRow(RowA * 3 + 1, RowB * 3 + 1);
        SwapRow(RowA * 3 + 2, RowB * 3 + 2);
    }

    function SwapBigCol()
    {
        var bigindex = Math.floor(Math.random() * 3), ColA = bigindex, ColB = (bigindex + 1) % 3;
        SwapCol(ColA * 3, ColB * 3);
        SwapCol(ColA * 3 + 1, ColB * 3 + 1);
        SwapCol(ColA * 3 + 2, ColB * 3 + 2);
    }

    // 原始数据
    var sourcenum = "843215697172396485695748132254139876317682954968574213421857369789463521536921748"
    var s = new Array(9);
    for (var i = 0; i < 9; i++)
    {
        s[i] = new Array(9);
        for (j = 0; j < 9; j++)
        {
            s[i][j] = sourcenum.substr(i * 9 + j, 1);
        }
    }

    // 交换
    var times = Math.floor(Math.random() * 9) + 17;
    var ctype = 0;//0:swaprow,1:swapcol,2:swapbigrow,3:swapbigcol
    for (i = 0; i < times; i += 1)
    {
        ctype = Math.floor((Math.random() * 10) % 4);
        if (ctype == 0)
            SwapRow();
        else if (ctype == 1)
            SwapCol();
        else if (ctype == 2)
            SwapBigRow();
        else if (ctype == 3)
            SwapBigCol();
    }

    // 挖空

    // var emptyNumber = l;
     var emptyNumber = 9;
    for (i = 0; i < emptyNumber; )
    {
        random_index = Math.floor(Math.random() * 80 + 1);
        row = parseInt(random_index / 9);
        col = random_index % 9;
        if (s[row][col] != 0)
        {
            s[row][col] = 0;
            i++;
        }
    }
    // 重新组合
    var newsource = "";
    for (i = 0; i < 9; i++)
    {
        for (j = 0; j < 9; j++)
        {
            newsource += s[i][j]
        }
    }
    return newsource;
}

function setTime() {
    var hour = parseInt(timeIndex / 3600);
    var minutes = parseInt((timeIndex % 3600) / 60);
    var seconds = parseInt(timeIndex % 60);
    hour = hour < 10 ? "0" + hour : hour;
    minutes = minutes < 10 ? "0" + minutes : minutes;
    seconds = seconds < 10 ? "0" + seconds : seconds;
    $("#divTime").text(hour + ":" + minutes + ":" + seconds);
    timeIndex++;
}
function showInstruct() {
    $.layer({
        type: 1, //0-4的选择,
        title: false,
        border: [0],
        closeBtn: [0],
        shadeClose: true,
        area: ['350px', '220px'],
        page: {html: '<p></p><br><br><p>玩法：把有颜色的方块拖入大九宫格中，使得横，竖，小九宫格内的数字都是1-9</p>'}
    });
}

function showHero() {
    var heroHtml='<br><p style="font-size:20px;text-align:center;">总英雄榜</p><br>'+'<p>排名&nbsp&nbsp   玩家&nbsp&nbsp    成绩</p><hr/>';
    $.post("/get_total_rank_list/", {"role":"user"},
      function(data){    
        var dataObj=eval("("+data+")");
        if(dataObj.state==0)
{
    alert("远程服务端无法连接");
    return;
}
        var i=1;
        $.each(dataObj.rank_list, function(index, object){
            heroHtml += "<p>"+i+"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp" + object.name + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp" + object.time + "</p><hr/>"
            i++;
        });
    $.layer({
        type: 1, //0-4的选择,
        title: false,
        border: [0],
        closeBtn: [0],
        shadeClose: true,
        area: ['480px', '580px'],
        page: {html:heroHtml }
    });
    });
}

function showlocalHero() {
    var heroHtml = '<br><p style="font-size:20px;text-align:center;">英雄榜</p><br>'+'<p>排名&nbsp&nbsp   玩家&nbsp&nbsp    成绩</p><hr/>';
     $.post("/get_rank_list/", {"role":"user"},
      function(data){
        var dataObj=eval("("+data+")");
        alert(dataObj.rank_list.length);
        var i=1;
        $.each(dataObj.rank_list, function(index, object){
            heroHtml += '<p>'+i+"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+ object.name + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp" + object.time +'秒'+ "</p><hr/>"
            i++;
        });
    $.layer({
        type: 1, //0-4的选择,
        title: false,
        border: [0],
        closeBtn: [0, false],
        shade: [0.8, '#000'],
        shadeClose: true,
        area: ['480px', '580px'],
        page: {html: heroHtml }
    });
    });
}

