package cn.sharesdk.ane;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import m.framework.utils.Hashon;
import m.framework.utils.UIHandler;

import android.os.Handler.Callback;
import android.os.Message;
import android.widget.Toast;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ShareSDKUtils extends FREContext implements FREExtension, FREFunction, PlatformActionListener {
	private Hashon hashon;

	public ShareSDKUtils() {
		super();
		UIHandler.prepare();
		hashon = new Hashon();
	}
	
	public FREContext createContext(String contextType) {
		return this;
	}

	public void initialize() {
		
	}
	
	public void dispose() {
		
	}
	
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("ShareSDKUtils", this);
		return functionMap;
	}
	
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			String json = args[0] == null ? null : args[0].getAsString();
			if (json != null) {
				HashMap<String, Object> data = hashon.fromJson(json);
				if (data != null && data.containsKey("action")) {
					String action = (String) data.get("action");
					@SuppressWarnings("unchecked")
					HashMap<String, Object> params = (HashMap<String, Object>) data.get("params");
					String resp = null;
					if ("initSDK".equals(action)) {
						resp = initSDK(params);
					} else if ("stopSDK".equals(action)) {
						resp = stopSDK(params);
					} else if ("setPlatformConfig".equals(action)) {
						resp = setPlatformConfig(params);
					} else if ("authorize".equals(action)) {
						resp = authorize(params);
					} else if ("removeAuthorization".equals(action)) {
						resp = removeAuthorization(params);
					} else if ("isVAlid".equals(action)) {
						resp = isVAlid(params);
					} else if ("getUserInfo".equals(action)) {
						resp = getUserInfo(params);
					} else if ("share".equals(action)) {
						resp = share(params);
					} else if ("multishare".equals(action)) {
						resp = multishare(params);
					} else if ("onekeyShare".equals(action)) {
						resp = onekeyShare(params);
					} else if ("showShareView".equals(action)) {
						resp = showShareView(params);
					} else if ("toast".equals(action)) {
						resp = toast(params);
					}
					return resp == null ? null : FREObject.newObject(resp);
				}
			}
		} catch (Throwable t) {
			t.printStackTrace();
		}
		return null;
	}

	public void onComplete(Platform platform, int action, HashMap<String, Object> res) {
		int platformId = ShareSDK.platformNameToId(platform.getName());
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("platform", platformId);
		map.put("action", getActionName(action));
		map.put("status", 1); // Success = 1, Fail = 2, Cancel = 3
		map.put("res", res);
		String level = hashon.fromHashMap(map);
		dispatchStatusEventAsync("SSDK_PA", level);
	}

	public void onError(Platform platform, int action, Throwable t) {
		int platformId = ShareSDK.platformNameToId(platform.getName());
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("platform", platformId);
		map.put("action", getActionName(action));
		map.put("status", 2); // Success = 1, Fail = 2, Cancel = 3
		map.put("res", throwableToMap(t));
		String level = hashon.fromHashMap(map);
		dispatchStatusEventAsync("SSDK_PA", level);
	}

	public void onCancel(Platform platform, int action) {
		int platformId = ShareSDK.platformNameToId(platform.getName());
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("platform", platformId);
		map.put("action", getActionName(action));
		map.put("status", 3); // Success = 1, Fail = 2, Cancel = 3
		String level = hashon.fromHashMap(map);
		dispatchStatusEventAsync("SSDK_PA", level);
	}
	
	private HashMap<String, Object> throwableToMap(Throwable t) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("msg", t.getMessage());
		ArrayList<HashMap<String, Object>> traces = new ArrayList<HashMap<String, Object>>();
		for (StackTraceElement trace : t.getStackTrace()) {
			HashMap<String, Object> element = new HashMap<String, Object>();
			element.put("cls", trace.getClassName());
			element.put("method", trace.getMethodName());
			element.put("file", trace.getFileName());
			element.put("line", trace.getLineNumber());
			traces.add(element);
		}
		map.put("stack", traces);
		Throwable cause = t.getCause();
		if (cause != null) {
			map.put("cause", throwableToMap(cause));
		}
		return map;
	}
	
	private String getActionName(int action) {
		switch (action) {
			case 1: return "authorize";
			case 8: return "getUserInfo";
			case 9: return "share";
		}
		return null;
	}
	
	// ============================ Java Actions ============================

	private String initSDK(HashMap<String, Object> params) {
		String appkey = (String) params.get("appkey");
		boolean enableStatistics = !"false".equals(params.get("enableStatistics"));
		ShareSDK.initSDK(getActivity(), appkey, enableStatistics);
		return null;
	}
	
	private String stopSDK(HashMap<String, Object> params) {
		ShareSDK.stopSDK(getActivity());
		return null;
	}
	
	private String setPlatformConfig(HashMap<String, Object> params) {
		try {
			int platformId = (Integer) params.get("platform");
			String platform = ShareSDK.platformIdToName(platformId);
			@SuppressWarnings("unchecked")
			HashMap<String, Object> devInfo = (HashMap<String, Object>) params.get("config");
			ShareSDK.setPlatformDevInfo(platform, devInfo);
		} catch (Throwable t) {
			t.printStackTrace();
		}
		return null;
	}
	
	private String authorize(HashMap<String, Object> params) {
		int platformId = (Integer) params.get("platform");
		String platformName = ShareSDK.platformIdToName(platformId);
		Platform platform = ShareSDK.getPlatform(getActivity(), platformName);
		platform.setPlatformActionListener(this);
		platform.authorize();
		return null;
	}
	
	private String removeAuthorization(HashMap<String, Object> params) {
		int platformId = (Integer) params.get("platform");
		String platformName = ShareSDK.platformIdToName(platformId);
		Platform platform = ShareSDK.getPlatform(getActivity(), platformName);
		platform.removeAccount();
		return null;
	}
	
	private String isVAlid(HashMap<String, Object> params) {
		int platformId = (Integer) params.get("platform");
		String platformName = ShareSDK.platformIdToName(platformId);
		Platform platform = ShareSDK.getPlatform(getActivity(), platformName);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("isValid", platform.isValid());
		return hashon.fromHashMap(map);
	}
	
	private String getUserInfo(HashMap<String, Object> params) {
		int platformId = (Integer) params.get("platform");
		String platformName = ShareSDK.platformIdToName(platformId);
		Platform platform = ShareSDK.getPlatform(getActivity(), platformName);
		platform.setPlatformActionListener(this);
		platform.showUser(null);
		return null;
	}
	
	private String share(HashMap<String, Object> params) {
		int platformId = (Integer) params.get("platform");
		String platformName = ShareSDK.platformIdToName(platformId);
		Platform platform = ShareSDK.getPlatform(getActivity(), platformName);
		platform.setPlatformActionListener(this);
		@SuppressWarnings("unchecked")
		HashMap<String, Object> shareParams = (HashMap<String, Object>) params.get("shareParams");
		ShareParams sp = new ShareParams(shareParams);
		int shareType = sp.getShareType();
		if (shareType > 0) {
			sp.setShareType(iosTypeToAndroidType(shareType));
		}
		platform.share(sp);
		return null;
	}
	
	private int iosTypeToAndroidType(int type) {
		switch (type) {
			case 1: return Platform.SHARE_IMAGE;
			case 2: return Platform.SHARE_WEBPAGE;
			case 3: return Platform.SHARE_MUSIC;
			case 4: return Platform.SHARE_VIDEO;
			case 5: return Platform.SHARE_APPS;
			case 6: 
			case 7: return Platform.SHARE_EMOJI;
			case 8: return Platform.SHARE_FILE;
		}
        return Platform.SHARE_TEXT;
	}
	
	private String multishare(HashMap<String, Object> params) {
		@SuppressWarnings("unchecked")
		ArrayList<Integer> platforms = (ArrayList<Integer>) params.get("platforms");
		@SuppressWarnings("unchecked")
		HashMap<String, Object> shareParams = (HashMap<String, Object>) params.get("shareParams");
		ShareParams sp = new ShareParams(shareParams);
		for (Integer platformId : platforms) {
			String platformName = ShareSDK.platformIdToName(platformId.intValue());
			Platform platform = ShareSDK.getPlatform(getActivity(), platformName);
			platform.setPlatformActionListener(this);
			platform.share(sp);
		}
		return null;
	}
	
	private String onekeyShare(HashMap<String, Object> params) {
		@SuppressWarnings("unchecked")
		HashMap<String, Object> map = (HashMap<String, Object>) params.get("shareParams");
		if (map != null) {
			OnekeyShare oks = new OnekeyShare();
			if (map.containsKey("title")) {
				oks.setTitle(String.valueOf(map.get("title")));
			}
			if (map.containsKey("titleUrl")) {
				oks.setTitleUrl(String.valueOf(map.get("titleUrl")));
			}
			if (map.containsKey("text")) {
				oks.setText(String.valueOf(map.get("text")));
			}
			if (map.containsKey("imagePath")) {
				oks.setImagePath(String.valueOf(map.get("imagePath")));
			}
			if (map.containsKey("imageUrl")) {
				oks.setImageUrl(String.valueOf(map.get("imageUrl")));
			}
			if (map.containsKey("comment")) {
				oks.setComment(String.valueOf(map.get("comment")));
			}
			if (map.containsKey("site")) {
				oks.setSite(String.valueOf(map.get("site")));
			}
			if (map.containsKey("url")) {
				oks.setUrl(String.valueOf(map.get("url")));
			}
			if (map.containsKey("siteUrl")) {
				oks.setSiteUrl(String.valueOf(map.get("siteUrl")));
			}
			oks.setCallback(this);
			oks.show(getActivity());
		}
		return null;
	}
	
	private String showShareView(HashMap<String, Object> params) {
		@SuppressWarnings("unchecked")
		HashMap<String, Object> map = (HashMap<String, Object>) params.get("shareParams");
		if (map != null) {
			OnekeyShare oks = new OnekeyShare();
			if (map.containsKey("title")) {
				oks.setTitle(String.valueOf(map.get("title")));
			}
			if (map.containsKey("text")) {
				oks.setText(String.valueOf(map.get("text")));
			}
			if (map.containsKey("imagePath")) {
				oks.setImagePath(String.valueOf(map.get("imagePath")));
			}
			if (map.containsKey("imageUrl")) {
				oks.setImageUrl(String.valueOf(map.get("imageUrl")));
			}
			if (map.containsKey("comment")) {
				oks.setComment(String.valueOf(map.get("comment")));
			}
			if (map.containsKey("site")) {
				oks.setSite(String.valueOf(map.get("site")));
			}
			if (map.containsKey("url")) {
				oks.setUrl(String.valueOf(map.get("url")));
			}
			if (map.containsKey("siteUrl")) {
				oks.setSiteUrl(String.valueOf(map.get("siteUrl")));
			}
			oks.setCallback(this);
			int platform = (Integer) params.get("platform");
			String platformName = ShareSDK.platformIdToName(platform);
			oks.setPlatform(platformName);
			oks.show(getActivity());
		}
		return null;
	}
	
	private String toast(HashMap<String, Object> params) {
		final String message = (String) params.get("message");
		UIHandler.sendEmptyMessage(1, new Callback() {
			public boolean handleMessage(Message msg) {
				Toast.makeText(getActivity(), message, Toast.LENGTH_SHORT).show();
				return false;
			}
		});
		return null;
	}
	
}
