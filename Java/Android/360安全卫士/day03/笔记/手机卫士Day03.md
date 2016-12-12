## Day03 ##
- 设置向导
> 演示搜狗输入法设置向导
> 完成第一个向导页面Setup1Activity的布局文件

	- style样式介绍
	- 用到的系统图片

		  android:drawableLeft="@android:drawable/star_big_on"//五角星
		  android:src="@android:drawable/presence_online" //小点选中
		  android:src="@android:drawable/presence_invisible" //小点不选中
	
- selector介绍

		1. 查看系统style.xml中有关Button样式的描述, 寻找Button的背景xml
			 <style name="Widget.Holo.Light.Button" parent="Widget.Button">

		2. 查看谷歌官方文档, 了解selector的详细设置方法
			App Resources>Resource Types>Drawable>State List
			拷贝Example的代码,在项目中运行.使用美图秀秀作图 50*50

		3. 使用准备好的图片创建新的selector, 设置给引导页面和Dialog

- 9patch图 

	> *.9.png

	android手机上,可以按需求自动拉伸的图片

	> 制作9Patch图: sdk/tools/draw9patch.bat

	- 上边线控制水平拉伸
	- 左边线控制竖直拉伸
	- 右边线和下边线控制内容区域

- 完成4个设置引导页

		1. Button 样式统一style
		2. 上一页和下一页逻辑处理

- 完成手机防盗页布局

> "重新进入设置向导" 按钮样式调整, 使用TextView添加selector,  
> android:clickable="true", 处理该按钮的点击事件

- Shape介绍

		1. 查看官方文档有关Shape的介绍
			App Resources>Resource Types>Drawable>Shape Drawable
			拷贝Example的代码,在项目中运行

		2. 演示shape下的几个属性
			
			<?xml version="1.0" encoding="utf-8"?>
			<shape xmlns:android="http://schemas.android.com/apk/res/android"
		    android:shape="rectangle" >
		
		    <!-- 圆角弧度 -->
		    <corners android:radius="5dp" />
		    <!-- 渐变 <gradient android:startColor="#ff0000" android:endColor="#00ff00" /> -->
		    
		    <!-- 填充色 -->
		    <solid android:color="#fff" />
		
		    <!-- 边框(虚线) <stroke android:width="1dp" android:color="#000000" android:dashWidth="8dp" android:dashGap="3dp"/> -->
			</shape>

- Activity切换动画

> 下一页动画

	trans_in.xml

	<?xml version="1.0" encoding="utf-8"?>
	<translate
	    android:fromXDelta="100%p" android:toXDelta="0"
	    android:duration="500"
	    xmlns:android="http://schemas.android.com/apk/res/android">
	
	</translate>

	trans_out.xml

	<?xml version="1.0" encoding="utf-8"?>
	<translate
	    android:fromXDelta="0" android:toXDelta="-100%p"
	    android:duration="500"
	    xmlns:android="http://schemas.android.com/apk/res/android">
	
	</translate>

> 上一页动画

	trans_pre_in.xml

	<?xml version="1.0" encoding="utf-8"?>
	<translate
	    android:fromXDelta="-100%p" android:toXDelta="0"
	    android:duration="500"
	    xmlns:android="http://schemas.android.com/apk/res/android">
	
	</translate>

	trans_pre_out.xml

	<?xml version="1.0" encoding="utf-8"?>
	<translate
	    android:fromXDelta="0" android:toXDelta="100%p"
	    android:duration="500"
	    xmlns:android="http://schemas.android.com/apk/res/android">
	
	</translate>

> Activity切换的动画效果
> 
	overridePendingTransition(R.anim.trans_in, R.anim.trans_out);//Activity切换的动画效果

- 手势识别器

		detector = new GestureDetector(this,
				new GestureDetector.SimpleOnGestureListener() {
					@Override
					public boolean onFling(MotionEvent e1, MotionEvent e2,
							float velocityX, float velocityY) {

						if (Math.abs(e1.getRawY() - e2.getRawY()) > 100) {
							Toast.makeText(BaseSetupActivity.this, "不能这样划哦!",
									Toast.LENGTH_SHORT).show();
							return true;
						}
						
						if (Math.abs(velocityX) < 100) {
							Toast.makeText(BaseSetupActivity.this, "速度太慢啦!",
									Toast.LENGTH_SHORT).show();
							return true;
						}
						
						if (e2.getRawX() - e1.getRawX() > 200) {
							Log.d("Test", "显示上一页");
							showPrevious();
							return true;
						}

						if (e1.getRawX() - e2.getRawX() > 200) {
							Log.d("Test", "显示下一页");
							showNext();
							return true;
						}

						return super.onFling(e1, e2, velocityX, velocityY);
					}
				});

		@Override
		public boolean onTouchEvent(MotionEvent event) {
			detector.onTouchEvent(event);
			return super.onTouchEvent(event);
		}

- 代码重构, 抽取父类

> BaseSetupActivity
	
		// 展示下一页
		public abstract void showNext();
	
		// 展示上一页
		public abstract void showPrevious();
	
		// 下一页按钮点击
		public void next(View view) {
			showNext();
		}
	
		// 上一页按钮点击
		public void previous(View view) {
			showPrevious();
		}


- 手机防盗流程梳理

- sim卡绑定页面实现(Setup2Activity)

		TelephonyManager mTelePhonyManager;
		mTelePhonyManager = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
	
		String simSerialNumber = mTelePhonyManager.getSimSerialNumber();// 获取sim卡序列号
	
		需要权限: <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
	
		将序列号保存在sp中,根据sp是否有值来更新选择框状态

- 监听开机启动,检测sim卡变化

		 <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

		 <receiver android:name=".receiver.BootCompleteReceiver" >
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>

		如果发现当前sim卡和sp中保存的不一致,需要向安全号码发送报警短信

- 读取联系人Demo

		/**
		 * 读取联系人
		 */
		private ArrayList<HashMap<String, String>> readContacts() {
			ArrayList<HashMap<String, String>> contacts = new ArrayList<HashMap<String, String>>();
	
			ContentResolver resolver = getContentResolver();
			Uri uriRaw = Uri.parse("content://com.android.contacts/raw_contacts");// raw_contacts表的uri
			Uri uriData = Uri.parse("content://com.android.contacts/data");// data表的uri
	
			Cursor cursor = resolver.query(uriRaw, new String[] { "contact_id" },
					null, null, null);
	
			if (cursor != null) {
				while (cursor.moveToNext()) {
					String id = cursor.getString(0);
					Cursor dataCursor = resolver.query(uriData, new String[] {
							"data1", "mimetype" }, "raw_contact_id=?",
							new String[] { id }, null);
					if (dataCursor != null) {
						HashMap<String, String> map = new HashMap<String, String>();
						while (dataCursor.moveToNext()) {
							String data = dataCursor.getString(0);
							String mimeType = dataCursor.getString(1);
	
							if ("vnd.android.cursor.item/phone_v2".equals(mimeType)) {
								map.put("phone", data);// 设置手机号码
							} else if ("vnd.android.cursor.item/name"
									.equals(mimeType)) {
								map.put("name", data);// 设置名称
							}
						}
	
						contacts.add(map);
					}
				}
			}
	
			return contacts;
		}

		SimpleAdapter adapter = new SimpleAdapter(this, contacts,
				R.layout.list_contact_item, new String[] { "name", "phone" },
				new int[] { R.id.tv_name, R.id.tv_phone });
		lvList.setAdapter(adapter);

		需要配置权限 
		<uses-permission android:name="android.permission.READ_CONTACTS" />

- 将联系人模块导入到项目中, 点击"选择联系人",跳转到联系人列表页

		通过startActivityForResult方式跳转,可以获取联系人页面的回传数据

		SelectContactActivity:

		Intent intent = new Intent();
		intent.putExtra("phone", phone);	
		setResult(Activity.RESULT_OK, intent);
		finish();
		-------------------
		Setup3Activity:

		@Override
		protected void onActivityResult(int requestCode, int resultCode, Intent data) {
			System.out.println("onActivityResult:" + resultCode);
			if (resultCode == Activity.RESULT_OK) {
				String phone = data.getStringExtra("phone");
	
				phone = phone.replace("-", "");//去掉"-"
				phone = phone.replace(" ", "");//去掉空格
	
				etPhoneNumber.setText(phone);
			}
	
			super.onActivityResult(requestCode, resultCode, data);
		}

		 <EditText
	        android:id="@+id/et_phone_number"
	        android:layout_width="match_parent"
	        android:layout_height="wrap_content"
	        android:inputType="phone"//设定键盘类型为电话号码
	        android:hint="请输入或选择安全号码"
         >

		//如果安全号码不为空,更新EditText
		String phone = mSp.getString("safe_phone", null);
		if (!TextUtils.isEmpty(phone)) {
			etPhoneNumber.setText(phone);
		}

		//跳转下一个页面
		String phone = etPhoneNumber.getText().toString().trim();// 过滤掉两侧空格后,获取号码信息

		if (TextUtils.isEmpty(phone)) {
			Toast.makeText(this, "必须设定安全号码!", Toast.LENGTH_SHORT).show();
			return;
		}

		mSp.edit().putString("safe_phone", phone).commit();// 保存电话号码

- 防盗保护页面状态更新(LostFindActivity)

		//判断防盗保护是否开启,更新图标状态
		boolean protecting = sp.getBoolean("protecting", false);
		if (protecting) {
			ivProtect.setImageResource(R.drawable.lock);
		} else {
			ivProtect.setImageResource(R.drawable.unlock);
		}
		
		tvSafePhone.setText(sp.getString("safe_phone", ""));//更新安全号码
