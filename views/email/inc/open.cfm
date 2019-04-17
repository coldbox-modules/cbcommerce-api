<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width" />
</head>

<body>
    <style>
        <cfinclude template="/cbCommerce/includes/css/email.css">
    </style>
    <table class="container" align="center">
        <tr>
            <td>
                <table class="row">
                    <tr>
                        <th style="text-align:center" class="small-12 large-8 first" valign="top" style="text-align:center">
                            <cfoutput>
                            <a href="#cb.linkHome()#" class="logo-link" style="display:inline-block; margin-top: 20px;">
                                <img src="#cb.linkHome()##cb.themeSetting( 'headerLogo' )#" style="max-height:200px;max-width:200px;" alt="logo" />
                            </a>
                            </cfoutput>
                        </th>
                    </tr>
                    <tr>
                        <td class="small-12 large-8 columns" valign="top">
                            <div class="mail-content">
<!-- end opening -->