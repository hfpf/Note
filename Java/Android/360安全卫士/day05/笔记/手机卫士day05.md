- 手机定位

	- 网络定位

			根据IP显示具体的位置, 原理是建立一个库那个IP地址对应那个地方；早期警方破案就采用此特点；

			纯真IP数据库软件介绍

		    有局限性：针对固定的IP地址。
		    如果手机网或者ip地址是动态分布IP，这个偏差就很大。这种情况是无法满足需求的。

	- 基站定位

			工作原理：手机能打电话，是需要基站的。手机定位也是用基站的。
			手机附近能收到3个基站的信号，就可以定位了。
			基站定位有可能很准确，比如基站多的地方；
			如果基站少的话就会相差很大。
			精确度：几十米到几公里不等；

	- GPS定位

			至少需要3颗卫星；
			特点是：需要搜索卫星， 头顶必须是空旷的；
			影响条件：云层、建筑、大树。

			卫星：美国人、欧洲人的卫星。
			北斗：中国的，但没有民用，只是在大巴，战机等使用。

			A-GPS: 通过GPS和网络共同定位,弥补GPS的不足, 精确度可达到15米以内, 一般手机都采用此种定位方式

- 定位Demo演示

		lm = (LocationManager) getSystemService(LOCATION_SERVICE);//获取系统位置服务
		List<String> allProviders = lm.getAllProviders();//获取所有位置提供者

		listener = new MyLocationListener();//位置监听器
		lm.requestLocationUpdates(LocationManager.PASSIVE_PROVIDER, 0, 0,
				listener);//更新位置, 参2和参3设置为0,表示只要位置有变化就立即更新

		class MyLocationListener implements LocationListener {

		//位置发生变化
		@Override
		public void onLocationChanged(Location location) {
			System.out.println("onLocationChanged");
			String longitude = "经度:" + location.getLongitude();
			String latitude = "纬度:" + location.getLatitude();
			String accuracy = "精确度:" + location.getAccuracy();
			String altitude = "海拔:" + location.getAltitude();

			tvLocation.setText(longitude + "\n" + latitude + "\n" + accuracy
					+ "\n" + altitude);
		}

		//位置提供者的状态发生变化
		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
			System.out.println("onStatusChanged");
		}

		//位置提供者可用
		@Override
		public void onProviderEnabled(String provider) {
			System.out.println("onProviderEnabled");
		}

		//位置提供者不可用
		@Override
		public void onProviderDisabled(String provider) {
			System.out.println("onProviderDisabled");
		}

		}
	
		@Override
		protected void onDestroy() {
			super.onDestroy();
			lm.removeUpdates(listener);//为了节省性能,当页面销毁时,删除位置更新的服务
			listener = null;
		}
	
		需要权限:
		<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>//获取准确GPS坐标的权限
	    <uses-permission android:name="android.permission.ACCESS_MOCK_LOCATION"/>//允许模拟器模拟位置坐标的权限
	    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>//获取粗略坐标的权限(网络定位时使用)

- 火星坐标

		获取到坐标后在谷歌地图上查询,发现坐标有所偏移, 不准确.这是因为中国的地图服务,为了国家安全, 坐标数据都经过了政府加偏处理, 加偏处理后的坐标被称为火星坐标.
	
		技术牛人通过对美国地图和中国地图的比对,生成了一个查询数据库, 专门用与标准坐标和火星坐标的转换.导入数据库文件axisoffset.dat和工具类ModifyOffset.java,创建一个java工程进行演示

		public static void main(String[] args) {
			try {
				ModifyOffset offset = ModifyOffset.getInstance(Demo.class
						.getResourceAsStream("axisoffset.dat"));//加载数据库文件
				PointDouble s2c = offset.s2c(new PointDouble(116.2821962,
						40.0408444));//标准坐标转为火星坐标
				System.out.println(s2c);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

- 开启服务,动态存储最新的坐标

		LocationService

		public void onCreate() {
			lm = (LocationManager) getSystemService(LOCATION_SERVICE);// 获取系统位置服务
	
			Criteria criteria = new Criteria();
			criteria.setAccuracy(Criteria.ACCURACY_FINE);// 准确度良好
			criteria.setCostAllowed(true);// 是否允许花费(比如网络定位)
			String bestProvider = lm.getBestProvider(criteria, true);// 获取当前最好的位置提供者
	
			System.out.println("位置提供者:" + bestProvider);
	
			listener = new MyLocationListener();// 位置监听器
			lm.requestLocationUpdates(bestProvider, 0, 0, listener);// 更新位置,
																	// 参2和参3		设置为0,表示只要位置有变化就立即更新
		};

		// 位置发生变化
		@Override
		public void onLocationChanged(Location location) {
			String longitude = "j:" + location.getLongitude() + "\n";
			String latitude = "w:" + location.getLatitude() + "\n";
			String accuracy = "a:" + location.getAccuracy() + "\n";


			// 保存经纬度信息
			SharedPreferences sp = getSharedPreferences("config", MODE_PRIVATE);
			sp.edit()
					.putString("last_location", longitude + latitude + accuracy)
					.commit();
			stopSelf();// 停止位置服务
		}

		----------------------------------

		SmsReceiver

		if ("#*location*#".equals(body)) {
			System.out.println("获取手机地理位置");
			context.startService(new Intent(context, LocationService.class));// 开启位置服务

			SharedPreferences sp = context.getSharedPreferences("config",
					Context.MODE_PRIVATE);
			String location = sp.getString("last_location", null);

			String reply = location;
			if (TextUtils.isEmpty(reply)) {
				reply = "getting location...";
			}

			SmsManager.getDefault().sendTextMessage(address, null, reply,
					null, null);

			abortBroadcast();// 中断广播的传递
		}

	> 注意添加权限!

	> 项目演示
	> 
	> 开启两个模拟器,发送短信#*location*#,查看是否可以收到经纬度的短信.第一次发送时,sp中没有保存,返回的是"getting location...", 为了保证模拟器能更新sp,需要在控制台发送模拟的经纬度信息. LocationService启动后获取经纬度,一旦获取成功,马上停止服务,这样可以节省耗电量. 演示服务开启和结束的场景.

- 超级管理员

> Administration官方文档介绍: http://developer.android.com/guide/topics/admin/device-admin.html
> 
> 网站推荐: http://www.androiddevtools.cn/ 查看中文文档

> 应用: 锁屏, 清除系统数据

> ApiDemo中的案例演示

	配置超级管理员步骤:
	1. 自定义Receiver,继承DeviceAdminReceiver
	2. 配置manifest

		 <receiver
            android:name=".AdminReceiver"
            android:description="@string/sample_device_admin_description"
            android:label="@string/sample_device_admin"
            android:permission="android.permission.BIND_DEVICE_ADMIN" >
            <meta-data
                android:name="android.app.device_admin"
                android:resource="@xml/device_admin_sample" />

            <intent-filter>
                <action android:name="android.app.action.DEVICE_ADMIN_ENABLED" />
            </intent-filter>
        </receiver>

	3. 添加配置文件@xml/device_admin_sample
	4. 获取DevicePolicyManager
	
		mDPM = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE)

	5. 一键锁屏
	
		mDPM.lockNow();//锁屏
		mDPM.resetPassword("123", 0);//设置锁屏密码
		注意: 必须先打开设置->安全->设备管理器的权限,否则运行崩溃

	6. 通过代码打开超级管理员权限
	
		public void openAdmin(View view) {
			Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
			ComponentName component = new ComponentName(this, AdminReceiver.class); 
	        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, component);
	        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION,
	               "打开超级管理员权限,可以一键锁屏,删除数据等");
			startActivity(intent);
		}

	7. 验证是否已经激活设备管理员

		ComponentName component = new ComponentName(this, AdminReceiver.class);
		if (mDPM.isAdminActive(component)) {
		}

	8. 桌面应用,一键锁屏, 应用市场搜索
	9. 如何卸载应用

		public void uninstall(View view) {
			ComponentName component = new ComponentName(this, AdminReceiver.class); 
			mDPM.removeActiveAdmin(component);//删除超级管理权限
			
			//跳转到卸载页面
			Intent intent = new Intent(Intent.ACTION_VIEW);
			intent.addCategory(Intent.CATEGORY_DEFAULT);
			intent.setData(Uri.parse("package:" + getPackageName()));
			startActivity(intent);
		}

	10. 清除数据

		//mDPM.wipeData(0);//恢复出厂设置
		//mDPM.wipeData(DevicePolicyManager.WIPE_EXTERNAL_STORAGE);//清除sdcard内容
 高级工具

		AToolsActivity

		布局文件:
		 <TextView
	        android:layout_width="match_parent"
	        android:layout_height="wrap_content"
	        android:background="@drawable/button"
	        android:drawableLeft="@android:drawable/ic_menu_camera"
	        android:drawablePadding="5dp"
	        android:gravity="center_vertical"
	        android:onClick="numberAddressQuery"
	        android:padding="5dp"
	        android:clickable="true"
	        android:text="电话归属地查询" >
	    </TextView>
		
- 号码归属地查询

		NumberAddressActivity

	- 原理分析
		- 网络查询(百度搜索手机归属地查询)
		- 数据库查询(数据库可以从网上下载,也可从网络购买)

	- sqlite导入本地数据库
		- 原始数据库, 有很多地名重复,可以进一步优化

				 将地名和卡类型的数据单独导入一张表中, 再将手机号前缀导入另外一张表,通过外键查询,数据量大大减小
				 select area,city,cardtype from info group by area,city,cardtype

		- 小米数据库

				1. 根据号码前7位查询外键
					select outkey from data1 where id="1861094"
				2. 根据外键查询位置信息
					select area,location from data2 where id=91
				3. 组合查询,直接根据号码前7位查询位置信息
					select area,location from data2 where id=(select outkey from data1 where id="1861094")

- 拷贝数据库
> SQLiteDatabase不支持直接从assets读取文件,所以要提前拷贝数据库

		NumberAddressDao

		public static final String PATH = "data/data/com.itheima.mobilesafeteach/files/address.db";

		SQLiteDatabase db = SQLiteDatabase.openDatabase(PATH, null,
				SQLiteDatabase.OPEN_READONLY);

		---------------------------------

		SplashActivity

		更新版本前,先拷贝数据库address.db
		/**
		 * 拷贝数据库
		 */
		private void copyDB(String dbName) {
			File file = new File(getFilesDir(), dbName);// 目的文件
	
			if (file.exists()) {
				System.out.println("数据库" + dbName + "已存在,无须拷贝!");
				return;
			}
	
			FileOutputStream out = null;
			InputStream in = null;
			try {
				out = new FileOutputStream(file);
				in = getAssets().open(dbName);// 源文件
	
				int len = 0;
				byte[] buffer = new byte[1024];
				while ((len = in.read(buffer)) > 0) {
					out.write(buffer, 0, len);
				}
	
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					out.close();
					in.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

- 查询数据库

		Cursor cursor = db
					.rawQuery(
							"select location from data2 where id=(select outkey from data1 where id=?)",
							new String[] { number.substring(0, 7) });
			if (cursor != null) {
				if (cursor.moveToNext()) {
					address = cursor.getString(0);
					System.out.println("address:" + address);
				}

				cursor.close();
			}

- 号码合法性判断

> 正则表达式
> 
> 手机号: "^1[345678]\\d{9}$"; 数字: "^\\d+$"


 	- 特殊号码判断

		switch (number.length()) {
			case 3:
				// 匪警电话 ,110,120等
				address = "报警电话";
				break;
			case 4:
				// 模拟器电话,5554,5556
				address = "模拟器";
				break;
			case 5:
				// 客服电话,95555
				address = "客服电话";
				break;
			case 7:
			case 8:
				// 本地电话
				address = "本地电话";
				break;

	- 座机判断

		if (number.startsWith("0") && number.length() > 10) {// 座机号码
			Cursor cursor = db.rawQuery(
					"select location from data2 where area=?",
					new String[] { number.substring(1, 4) });

			if (cursor.moveToNext()) {// 先查询前4位
				address = cursor.getString(0);
			}

			cursor.close();

			if (TextUtils.isEmpty(address)) {// 如果前4位没有数据,就查询前3位
				cursor = db.rawQuery(
						"select location from data2 where area=?",
						new String[] { number.substring(1, 3) });
				if (cursor.moveToNext()) {
					address = cursor.getString(0);
				}

				cursor.close();
			}
		}

> 注意: db.close();//关闭数据库

- 监听文字变化,动态查询

		etNumber.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				System.out.println("onTextChanged");
				if (s.length() >= 3) {
					String address = NumberAddressDao.getAddress(s.toString());
					if (!TextUtils.isEmpty(address)) {
						tvResult.setText(address);
					} else {
						tvResult.setText("无结果");
					}
				}
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				System.out.println("beforeTextChanged");
			}

			@Override
			public void afterTextChanged(Editable s) {
				System.out.println("afterTextChanged");
			}
		});

- 抖动效果

	1. 引入ApiDemo,查找抖动效果的代码
	2. 拷贝相关代码到自己的项目中,运行
	3. 代码解读,插补器介绍

			结合Interpolator的子类,如线性插补器和循环插补器的源码来分析,更容易理解

			Animation shake = AnimationUtils.loadAnimation(this, R.anim.shake);
			shake.setInterpolator(new Interpolator() {

				@Override
				public float getInterpolation(float x) {
					float y = x;//线程插补器
					return y;
				}
			});

- 振动效果

		private void vibrate() {
			Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
			// vibrator.vibrate(2000);//震动2秒
			long[] pattern = new long[] { 1000, 2000, 1000, 3000 };// 先等待1秒,再震动2秒,再等待1秒,再震动3秒...
			vibrator.vibrate(pattern, -1);// 参2等于-1时,表示不循环,大于等于0时,表示从以上数组的哪个位置开始循环
		}

		注意权限:  <uses-permission android:name="android.permission.VIBRATE"/>