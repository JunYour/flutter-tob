package com.ganchewang.tob

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import androidx.annotation.NonNull
// import cn.jiguang.jmlink_flutter_plugin.JmlinkFlutterPlugin

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private var openPageMethodChannel: MethodChannel?=null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val uri = intent.data
        if(uri !=null){
            val query = uri.query
            val page = uri.getQueryParameter("page")
            val data = uri.getQueryParameter("data")

            val settings = getSharedPreferences("page", Context.MODE_PRIVATE)
            val editor = settings.edit()
            editor.putString("page", page)
            editor.putString("data",data)
            // 提交本次编辑
            editor.apply()
        }
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
     
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"page").setMethodCallHandler(
                MethodChannel.MethodCallHandler { call, result ->
                    run {
                        if (call.method!!.contentEquals("jump")) {
                            val settings: SharedPreferences = getSharedPreferences("page", Context.MODE_PRIVATE)
                            val page = settings.getString("page",null)
                            val data = settings.getString("data",null)
                            val editor = settings.edit()
                            editor.clear()
                            result.success("$page,$data")
                        }
                    }
                }
        )











        super.configureFlutterEngine(flutterEngine)
    }

}




