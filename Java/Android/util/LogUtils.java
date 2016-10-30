package cn.qdgxy.logcat.util;

import android.util.Log;

/**
 * 日志小工具
 * create:2016-10-29 19:52
 *
 * @author 李欣
 * @version 1.0
 */
public class LogUtils {

    private static boolean enableLog = false;  // 控是否打开日志

    /**
     * error级别
     *
     * @param tag    tag标签，一般是类名
     * @param object 打印object.toString()
     */
    public static void e(String tag, Object object) {
        if (enableLog) {
            Log.e(tag, object.toString());
        }
    }

    /**
     * warn级别
     *
     * @param tag    tag标签，一般是类名
     * @param object 打印object.toString()
     */
    public static void w(String tag, Object object) {
        if (enableLog) {
            Log.w(tag, object.toString());
        }
    }

    /**
     * info级别
     *
     * @param tag    tag标签，一般是类名
     * @param object 打印object.toString()
     */
    public static void i(String tag, Object object) {
        if (enableLog) {
            Log.i(tag, object.toString());
        }
    }

    /**
     * debug级别
     *
     * @param tag    tag标签，一般是类名
     * @param object 打印object.toString()
     */
    public static void d(String tag, Object object) {
        if (enableLog) {
            Log.d(tag, object.toString());
        }
    }

    /**
     * verbose级别
     *
     * @param tag    tag标签，一般是类名
     * @param object 打印object.toString()
     */
    public static void v(String tag, Object object) {
        if (enableLog) {
            Log.v(tag, object.toString());
        }
    }
}
