package com.yandex.generator

import android.app.Application
import com.yandex.div.core.util.Assert

class TestApplication : Application() {

    init {
        Assert.setEnabled(true)
    }
}
