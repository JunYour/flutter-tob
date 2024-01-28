package com.ganchewang.tob

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
// import cn.jiguang.jmlink_flutter_plugin.JmlinkFlutterPlugin


class WelcomeActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("| WelcomeActivity | - ", "onCreate:")
        super.onCreate(savedInstanceState)
        //JmlinkFlutterPlugin.setData(intent.data)
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
        finish()
    }

    //@Override
    override fun onDestroy() {
        Log.d("| WelcomeActivity | - ", "onDestroy:")
        super.onDestroy()
    }

    override fun onNewIntent(intent: Intent?) {
        Log.d("| WelcomeActivity | - ", "onNewIntent:")
        super.onNewIntent(intent)
        setIntent(intent)
    }
}