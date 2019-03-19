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
                        <th style="text-align:center" class="small-12 large-6 columns first" valign="top">
                            <cfoutput>
                            <a href="#event.buildLink( url=cb.linkHome() )#" class="logo-link" style="display:inline-block; margin-top: 20px;">
                                <img src="#event.buildLink( url=cb.themeSetting( 'headerLogo' ) )#" style="max-height:100px;max-width:100px;" alt="logo" />
                            </a>
                            </cfoutput>
                        </th>
                    </tr>
                    <tr>
                        <td class="small-12 large-6 columns" valign="top">
                            <div class="mail-content">
<!-- end opening -->