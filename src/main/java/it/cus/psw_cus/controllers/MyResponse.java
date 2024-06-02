package it.cus.psw_cus.controllers;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MyResponse {
    public MyResponse(String str){
        message = str;
    }
    public MyResponse(){}
    // Getter e Setter
    private String message;

}

