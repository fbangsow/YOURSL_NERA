  * {
        box-sizing: border-box;
    }
    html,
    body {
        min-height: 100%;
    }
    a {
        text-decoration: none;
    }
    .backcolor {
        background-color: #e5e5e5;
    }
    .panel-info>.panel-heading {
        color: none !important;
        background-color: none !important;
        border-color: none !important;
        border: none !important;
    }
    .panel-body {
        border: none !important;
        border-top: none !important;
    }
    .main-header {
        text-align: center;
        color: black;
        text-shadow: #222 0px -1px 1px;
        width: 100%;
        left: 0;
        transition: all 0.3s ease;
    }
    .main-header a {
        position: absolute;
        left: 10px;
        font-size: 21px;
        top: 4px;
        text-decoration: none;
    }
    .page-wrap {
        float: right;
        width: 100%;
        transition: width 0.3s ease;
    }
    .main-nav {
        position: fixed;
        top: 0;
        width: 0;
        height: 100%;
        overflow-y: auto;
        transition: width 0.3s ease;
    }
    .main-nav a {
        display: block;
        background: linear-gradient(#3e3e3e, #383838);
        border-top: 1px solid #484848;
        border-bottom: 1px solid #2E2E2E;
        color: white;
        padding: 15px;
    }
    .main-nav a:hover,
    .main-nav a:focus {
        background: linear-gradient(#484848, #383838);
    }
    .main-nav:after {
        content: "";
        position: absolute;
        top: 0;
        right: 0;
        height: 100%;
        width: 34px;
    }
    .close-menu {
        display: none;
        top: 0px;
    }
    #main-nav:target {
        width: 200px;
    }
    #main-nav:target + .page-wrap {
        width: 82.5%;
    }
    #main-nav:target + .page-wrap .open-menu {
        display: none;
        top: 0px;
    }
    #main-nav:target + .page-wrap .close-menu {
        display: block;
    }
    #main-nav:target + .page-wrap .main-header {
        width: 100%;
        left: 20%;
    }
    .brdr {
        padding: 1% 0%;
        height: 720px;
        width: 200px;
        float: right;
        padding-left: 0px;
        !margin: 1% 0% 0% 0%;
        background-color: #FFFFFF;
    }
    .mrgn10 {
        margin: 10px;
        margin-left: 0px;
    }
    .imgdata {
           background-repeat: no-repeat;
    background-size: 100% 100%;
    padding: 0px !important;
    width: 79.2%;
    height: 100%;
    top: 10%;
    position: absolute;
    left: 10.4%;
    }
    .onoffswitch {
        position: relative;
        width: 80px;
        -webkit-user-select: none;
        top: -8px;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
    }
    .onoffswitch-checkbox {
        display: none;
    }
    .onoffswitch-label {
        display: block;
        overflow: hidden;
        cursor: pointer;
        border: 2px solid #70ca63;
        border-radius: 20px;
    }
    .onoffswitch-inner {
        display: block;
        width: 200%;
        margin-left: -100%;
        transition: margin 0.3s ease-in 0s;
    }
    .onoffswitch-inner:before,
    .onoffswitch-inner:after {
        display: block;
        float: left;
        width: 50%;
        height: 30px;
        padding: 0;
        line-height: 22px;
        font-size: 11px;
        color: white;
        font-family: 'Open Sans', sans-serif;
        font-weight: bold;
        box-sizing: border-box;
    }
    .onoffswitch-inner:before {
        content: "on";
        padding-left: 6px;
        background-color: #70CA63;
        color: #FFFFFF;
        margin-top: -4px;
    }
    .onoffswitch-inner:after {
        content: "off";
        padding-right: 6px;
        background-color: #EEEEEE;
        color: #999999;
        text-align: right;
        margin-top: -4px;
    }
    .panel-info>.panel-heading {
        color: #282828;
        background-color: #999999;
        border-color: #999999;
        !border: 1px solid #999999;
        border-top: 1.8px solid #2699D8 !important;
        border-bottom: 1px solid rgba(153, 153, 153, 0.52) !important;
        border-radius: 2px;
    }
    .panel.newpos {
        color: #282828;
        background-color: #E8E8E8;
        border-color: #999999;
        border: none;
        border-left: 5px solid #2699D8;
        border-radius: 0px;
    }
    .onoffswitch-switch {
        display: block;
        width: 16px;
        margin: 2px;
        background: #FFFFFF;
        position: absolute;
        top: 0px;
        bottom: 0;
        right: 23px;
        height: 15px;
        border-radius: 20px;
        transition: all 0.3s ease-in 0s;
    }
    .onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-inner {
        margin-left: 0;
    }
    .onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-switch {
        right: -6px;
    }
    .btn-primary.dropdown {
        color: #fff;
        background: #2699D8;
        border-color: #2699D8;
        !padding: 13.5px;
        margin: 0px;
        height: 26px;
        width: 25px;

    }
    .btn.dropdown {
    padding: 0px 4px;
    margin: 0px;
    }

    .primary.dropdown:hover,
    .primary.dropdown:active
     {
        background-color: #2699D8 ;
        border-color: #2699D8;
        margin: 0px;
    }
    .btn-primary.dropdown:hover,
    .btn-primary.dropdown:active
     {
        background-color: #2699D8 ;
        border-color: #2699D8;
        margin: 0px;
    }
    .devicesize {
        width: 100%;
        height: 100%;
        background-size: 100% 100%;
        background-repeat: no-repeat;
    }
    .hgtfordiv {
        height: 100%;
        width: 100%;
    }
    .btn-file {
        position: relative;
        overflow: hidden;
    }
    .modal-footer.brdertopnne {
        border-top: none;
    }
    .btn-file input[type=file] {
        position: absolute;
        top: 0;
        right: 0;
        min-width: 100%;
        min-height: 100%;
        font-size: 100px;
        text-align: right;
        filter: alpha(opacity=0);
        opacity: 0;
        outline: none;
        background: white;
        cursor: inherit;
        display: block;
    }
    .dragdown {
        width: 100%;
        height: 45px;
        border: 1px dashed #999999;
        text-align: center;
        font-size: 11px;
        background-color: #ffffff;
        color: #999999;
    }
    .input-group {
        position: relative;
        display: table;
        border-collapse: separate;
    }
    .panel-body {
        border-top: none;
        border-radius: 0px;
        padding: 15px 5px !important;
        background-color: rgba(232, 232, 232, 0.32);
    }
    .panel-body.selectdevice {
        background-color: #ffffff;
    }
    .input-group .form-control.formcontrol {
        z-index: 0 ;
    }
    .onoffswitch-label {
        height: 19px;
        width: 49px;
        margin-top: -10px;
        margin-left: 37px;
    }
    .brdernone.panel-info {
        
        border: none;
        border-top: none;
    }
    .panel-info.toppanel {
      
        
        border: 1px solid rgb(190, 180, 180);
        border-top: none;
        border-radius: 3px;
    }
    .title {
        font-size: 10;
    }
    .bootstrap-filestyle input[type="text"] {
        width: 75%;
    }
    .bootstrap-filestyle .btn {
        background: #2699D8 !important;
        border-radius: 0px 5px 5px 0px !important;
        color: white !important;

    }
    .btn.hgtmrgn {
       padding: 4px 0px;
       top: 0px;
       font-size: 12px;
       border: none;

    }
    .bootstrap-filestyle img {
        width: 27px;
    }
    .bootstrap-filestyle {
        display: -webkit-box !important;
    }
    .btn-file input[type=file] {
        background-image: none;
        background-color: #2699D8 !important;
        border-radius: none;
    }
    .item {
        min-height: 50px;
        min-width: 50px;
        border: 1px solid #000;
        float: right;
        transition: all 0.2s ease;
    }
    .col-md-9.colpadd {
        padding-right: 0px;
        position: relative;
        width: 77.5%;
        margin: 1% 0% 0% 0%;
    }
    .panel-info>.panel-heading {
        background-color: #E8E8E8 !important;
    }
    .panel-heading.settingimage {
        padding: 12px 47px;
    }
    .raduisbtn {
        !background-color: #5cb85c;
        padding: 1px 9px;
        color: #fff;
        border-radius: 1em;
        font-size: 1em;
        margin: 0em 1em 0 0em;
    }
    nav {
        border: 1px solid #BAB3B3;
        background: white;
    }
    body {
        background: #E5DCDC !important;
    }
    .panel-heading.bordernne {
        border: none;
    }
    .panel-info.brdernone {
        !border-color: #999999 !important;
        border-radius: 0px !important;
        border: none;

    }
    .wdthbrdrrdus {
        width: 87% !important;
        border-radius: 4px 0px 0px 4px;
    }
    .form-control.wdthbrdrrdus1 {
        width: 92% !important;
    }
    .panel-info>.panel-heading span {
        font-size: 14px !important;
    }
    .hgtmrgn {
        height: 26px;
        width: 25px
        
    }
    .panel.mrgnbtm {
        margin-bottom: 0px ;
        border-radius: 0px; 

    }
    .panel-heading.hdngbrdr {
        border-top: #e2e2e2;
    }
    .form-control.textarea {
        margin-top: 0%;
        height: none;
    }
    .navbar-brand.backgroundFile {
        font-size: 12px;
        line-height: 14.4px;
        padding: 4px 32px;
        !background-color: #E8E8E8;
        height: 39px;
        border-left: 4px solid #e8e8e8;
        color: rgb(153, 153,153);
        width: 100%;
    }
    .navbar-brand:hover,
    .navbar-default .navbar-brand:focus {
        background-color: #e5e5e5 !important;
        border-left: 4px solid #2699D8 !important;
    }
    .angdradrst {
        display: none;
    }
    .btn.butcoloredit {
        background-color: #2699D8 !important;
    }
    .btn.butcolordelete {
        background-color: red !important;
    }
    .btn.butcolorsave {
        background-color: #FFFFFF;
        color: #000000;
    }
    .small,
    small {
        font-size: 74% !important;
    }
    .glyphicon-plus:before {
        margin-left: 1px !important;
    }
    .btn-group-sm>.btn,
    .btn-sm {
        padding: 2px 10px !important;
    }
    .paneltitle {
        color: rgb(153, 153,153);
        font-family: 'Open Sans', sans-serif;
        font-size: 12px;
        font-style: normal;
        text-align: left;
        line-height: 14.4px;
        letter-spacing: 0em;
        opacity: 1;
    }
    .paneltitle.paneltitleview {
        font-size: 14px;
    }
    .paneltitlepopup {
        margin-left: 24px;
    }
    .btn.butcolordelete,
    .btn.butcoloredit,
    .btn.butcolorsave {
        padding: 13px 13px;
        font-size: 12px;
        letter-spacing: 0em;
        border-radius: 3px;
        !margin: 0px 7px;
    }
    .col-md-2.colmd2 {
        width: 11.666667%;
    }
    .form-control.formcontrol {
        height: 26px ;
    }
    .btn-default {
        color: #FFFFFF !important;
    }
    .colortitle {
        color: #2699D8 !important;
    }
    .marginnull {
        margin-bottom: 0px;
    }
    .Dradanddrop {
        margin: 8px 0px 0px 24px;
    }
    .addbutton,.addbutton:hover
    .addbutton:focus {
        background-color: #39b54a;
        color: #FFFFFF;
        letter-spacing: 0em;
        margin: 10px 0px 0px 20px;
    }
    .thstyle {
        font-size: 12px;
    }
    .form-control.margininput {
        margin: 1px;
    }
    .modal-header.popupheader {
        padding: 0.7em;
        background-color: #e5e5e5;
        border-radius: 5px 0px 0px 0px;
    }
    .modaltitle {
        font-size: 15px;
    }
    .btn.deletepop {
        padding: 6px 32px;
        margin: 0% 8% 0% 0%;
        background-color: #999999;
        color: #ffffff;
    }
    .btn.savepop {
        padding: 7.5px 30px;
        margin: 0% 15% 0% 0%;
        background-color: #2699D8;
        color: #ffffff;
        letter-spacing: 0em;
        font-size: 12px;
        font-family: 'Open Sans', sans-serif;
    }
    .col-md-9.colpadd {
        width: 79%;
        padding-left: 0px;
    }
    .open-menu.removeline {
        text-decoration: none;
        color: #2699D8;

    }
    .close-menu.removeline {
        text-decoration: none;
        color: #2699D8;
    }
    .heightview {
        height: 222px;
    }
    .panel.heightpoi {
        margin-bottom: 0px ;
        border-bottom: 1px dashed #999999;
    }
    .btn.savepos {
        width: 184px;
        height: 25px;
        margin: 39px 0px 0px 9px;
        background-color: #2699D8;
        padding: 3px 32px;
        border-radius: 5px;
        color: #ffffff !important;
        border: 0px;

    }
    .saveview {
        height: 105px;
    }
    .scrollbar {
        
        background: transparent;
        overflow-y: auto;
        margin: 0px 3px 0px 0px;
    }
    .force-overflow {
        min-height: 300px;
    }
    #style-3::-webkit-scrollbar-track {
        -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
        background-color: #F5F5F5;
    }
    #style-3::-webkit-scrollbar {
        width: 2px;
        background-color: #F5F5F5;
    }
    #style-3::-webkit-scrollbar-thumb {
        background-color: #999999;
    }
    .circleBase {
        border-radius: 50%;
        behavior: url(PIE.htc);
    }
    .type1 {
        width: 68px;
        height: 68px;
        background: #e8e8e8;
        border: 3px solid #39B54A;
    }
    .modalbody {
        background-color: #e8e8e8;
    }
    .tablemargin {
        margin: 20px 15px 0px 15px;
        height: 150px;
    }
    #style-1::-webkit-scrollbar-track {
        -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
        background-color: #F5F5F5;
    }
    #style-1::-webkit-scrollbar {
        width: 2px;
        background-color: #F5F5F5;
    }
    #style-1::-webkit-scrollbar-thumb {
        background-color: #999999;
    }
    .dropdown-menu.minwidth {
        min-width: 114px;
        padding: 0px 5px;

    }
    .dropdown-menu.minwidthpos {
        min-width: 188px;
        padding: 0px 5px;
    }
    .dropdown-menu.minwidthpoi {
        min-width: 221px;
        padding: 0px 5px;
    }
    .col-sm-5.colsm5 {
       padding-left: 0px; 
    }
    .col-md-3.colmd3 {
        width: 20%;
    }
    .popuptitle {
        margin: 2px 0px 0px 15px;
    }
    .popupdescription {
        margin: 2px 0px 0px 0px;
    }
    .tabletitle {
        margin: 0px 9px;
    }
    .tablestyle {

        background-color: #ffffff;
    }
    .btn.deletepop.focus, .btn.deletepop:focus, .btn.deletepop:hover {
        color: #ffffff;
    }
    .btn.addbutton.focus, .btn.addbutton:focus, .btn.addbutton:hover {
        color: #ffffff;
    }
    .btn.savepop.focus, .btn.savepop:focus, .btn.savepop:hover {
        color: #ffffff;
    }
    .btn.filtercls.focus, .btn.filtercls:focus, .btn.filtercls:hover {
        color: #ffffff;
    }
    .btn.cancelbutt.focus, .btn.cancelbutt:focus, .btn.cancelbutt:hover {
        color: #ffffff;
    }
    
    .popupdasheddiv {
        border-top: 1px dashed #999999;
    }
    .popupbottm {
        border-bottom: 1px dashed #999999;
        height: 230px;

    }
    .panel.bottomnone {
        border-bottom: none;
    }
    .checkbox1,.checkbox2 {
        width: 8px;
        height: 8px;
        background-color: #999999;
        float: right;
        margin: -13px -27px 0px 0px;
    }
    .btn.filtercls {
        width: 90px;
        height: 27px;
        position: absolute;
        margin: -4px 500px;
        background-color: #999999;
        color: #ffffff;
    }
    .imgforscrl {
        float: left;
        width: 31px;
        margin: 7px 7px 0px 7px;
    }
     #myfilter {
        width: 567px;
        height: 232px;
        border: 1px solid #999999;
        margin-left: 28%;
        background-color: #ffffff;
    }
    input[type=range] {
        -webkit-appearance: none;
        width: 300px;
    }
    input[type=range]::-webkit-slider-runnable-track {
        width: 300px;
        height: 1.5px;
        !background: red;
        border: none;
        border-radius: 3px;
    }
    input[type=range]::-webkit-slider-thumb {
        -webkit-appearance: none;
        border: none;
        height: 16px;
        width: 16px;
        border-radius: 50%;
        !background: red;
        margin-top: -6.5px;
        border: 2px solid #ffffff;
    }
    input[type=range]:focus {
        outline: 0px;
    }
    input[type=range]:focus::-webkit-slider-runnable-track {
        !background: red;
    }

    input[type=range]::-moz-range-track {
        width: 300px;
        height: 1.5px;
        background: red;
        border: none;
        border-radius: 3px;
    }
    input[type=range]::-moz-range-thumb {
        border: none;
        height: 16px;
        width: 16px;
        border-radius: 50%;
        background: goldenrod;
    }

    /*hide the outline behind the border*/
    input[type=range]:-moz-focusring{
        outline: 1px solid white;
        outline-offset: -1px;
    }

    input[type=range]::-ms-track {
        width: 300px;
        height: 5px;
        
        /*remove bg colour from the track, we'll use ms-fill-lower and ms-fill-upper instead */
        background: transparent;
        
        /*leave room for the larger thumb to overflow with a transparent border */
        border-color: transparent;
        border-width: 6px 0;

        /*remove default tick marks*/
        color: transparent;
    }
    input[type=range]::-ms-fill-lower {
        background: #777;
        border-radius: 10px;
    }
    input[type=range]::-ms-fill-upper {
        background: #ddd;
        border-radius: 10px;
    }
    input[type=range]::-ms-thumb {
        border: none;
        height: 16px;
        width: 16px;
        border-radius: 50%;
        background: goldenrod;
    }
    input[type=range]:focus::-ms-fill-lower {
        background: #888;
    }
    input[type=range]:focus::-ms-fill-upper {
        background: #ccc;
    }
    .btn.cancelbutt {
        color: #ffffff;
        margin: 22px 11px 23px 175px;
        background-color: #999999;
        padding: 6.05px 12px;

    }
    .filterclass {
        border: 1px solid #999999;

    }
    .modal-dialog.modaldialog {
        width: 650px;
        margin-left: 28%;
    }
    .mandatorybutt {
        margin: 0px 0px 0px 24px;
    }
    input[type="checkbox"]{
    cursor: pointer;
    -webkit-appearance: none;
    appearance: none;
    !background: #34495E;
    border-radius: 1px;
    box-sizing: border-box;
    position: relative;
    box-sizing: content-box ;
    width: 24px;
    height: 24px;
    border-width: 0;
    transition: all .3s linear;
    }
    input[type="checkbox"]:checked{
      background-color: #2ECC71;
    }
    input[type="checkbox"]:focus{
      outline: 0 none;
      box-shadow: none;
    }
    .Sliderrange {
        margin: 14px 0px 0px 0px;  
    }
    .dataslider {
        background-color: #e5e5e5;
        height: 40px;
    }
    .clickedpoi
    {
    background-color: #e5e5e5 !important;
    border-left: 4px solid #2699D8 !important;
    
    }
    @media (min-width: 600px) and (max-width: 1156px) {
     #main-nav:target + .page-wrap {
    width: 78.5% !important;
}
.rspnbndng1
{
    width:20% !important;
}
.btn.savepos
{
    width:90% !important;
    font-size:11px !important;
    padding:7px 32px !important;
}
.panel-info>.panel-heading span
{
    font-size:11px !important;
}
.panel-heading
{

    padding: 10px 7px !important;
}
.navbar-brand.backgroundFile {
 
    line-height: 12.4px;
    padding: 4px 32px;
    height: 42px;
    margin-bottom: -1px;
}
.panel-heading.settingimage {
    padding: 12px 47px !important;
}
} 
.btn[disabled]
{
    
    background:#e2e2e2;
    background-image:none;
}