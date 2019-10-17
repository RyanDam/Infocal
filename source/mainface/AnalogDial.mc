using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;

class AnalogDial extends Ui.Drawable {

	hidden var centerX;
    hidden var centerY;

	hidden var secondHandDisabled;

//	hidden var seco_font_1, seco_font_2, seco_font_3, seco_font_4, seco_font_5, seco_font_6;
	hidden var hour_font_1, hour_font_2, hour_font_3, hour_font_4, hour_font_5, hour_font_6;
	hidden var minu_font_1, minu_font_2, minu_font_3, minu_font_4, minu_font_5, minu_font_6;
//	hidden var seco_1, seco_2, seco_3, seco_4, seco_5, seco_6;
	hidden var hour_1, hour_2, hour_3, hour_4, hour_5, hour_6;
	hidden var minu_1, minu_2, minu_3, minu_4, minu_5, minu_6;

	var offset_x = 0;
	var offset_y = 0;
	var offset_rad = 0;

	function initialize(params) {
        Drawable.initialize(params);
        
        var size = Application.getApp().getView().getViewSize();
        centerX = size[0]/2;
    	centerY = size[1]/2;
    	
    	if (size[0] == 218) {
    		offset_x = -11;
    		offset_y = -11;
    		offset_rad = 10;
    	} else if (size[0] == 260) {
    		offset_x = 11;
    		offset_y = 11;
    	} else if (size[0] == 280) {
    		offset_x = 21;
    		offset_y = 21;
    	}
    	
    	secondHandDisabled = true;
    }
    
    function disableSecondHand() {
    	secondHandDisabled = true;
    }
    
    function enableSecondHand() {
    	secondHandDisabled = false;
    }
    
    function removeFont() {
    	hour_font_1 = null;
		hour_1 = null;
		hour_font_2 = null;
		hour_2 = null;
		hour_font_3 = null;
		hour_3 = null;
		hour_font_4 = null;
		hour_4 = null;
		hour_font_5 = null;
		hour_5 = null;
		hour_font_6 = null;
		hour_6 = null;
		
		minu_font_1 = null;
		minu_1 = null;
		minu_font_2 = null;
		minu_2 = null;
		minu_font_3 = null;
		minu_3 = null;
		minu_font_4 = null;
		minu_4 = null;
		minu_font_5 = null;
		minu_5 = null;
		minu_font_6 = null;
		minu_6 = null;
		
//		seco_font_1 = null;
//		seco_1 = null;
//		seco_font_2 = null;
//		seco_2 = null;
//		seco_font_3 = null;
//		seco_3 = null;
//		seco_font_4 = null;
//		seco_4 = null;
//		seco_font_5 = null;
//		seco_5 = null;
//		seco_font_6 = null;
//		seco_6 = null;
    }
    
    function checkCurrentFont() {
    
    	if (Application.getApp().getProperty("use_analog") == false) {
    		removeFont();
    		return;
    	}
    
    	var hour_i = getHourHandFragment() % 60;
    	if (hour_i >= 50) {
    		hour_font_1 = null;
    		hour_1 = null;
    		hour_font_2 = null;
    		hour_2 = null;
    		hour_font_3= null;
    		hour_3 = null;
    		hour_font_4 = null;
    		hour_4 = null;
    		hour_font_5 = null;
    		hour_5 = null;
    		if (hour_font_6 == null) {
	    		hour_font_6 = Ui.loadResource(Rez.Fonts.hour_6);
	    		hour_6 = [[0x213951,0x225551,0x23556d],
					[0x243d4b,0x253d67,0x26594b,0x275967],
					[0x284147,0x294163,0x2a5d47,0x2b5d63],
					[0x2c4641,0x2d465d,0x2e6241,0x2f625d],
					[0x304b3d,0x314b59,0x32673d,0x336759],
					[0x345139,0x355155,0x366d55],
					[0x375736,0x385752,0x39576e,0x3a7352,0x3b736e],
					[0x3c5d33,0x3d5d4f,0x3e5d6b,0x3f794f],
					[0x406331,0x41634d,0x426369],
					[0x436a30,0x446a4c,0x456a68]];
			}
    	} else if (hour_i >= 40) {
    		hour_font_1 = null;
    		hour_1 = null;
    		hour_font_2 = null;
    		hour_2 = null;
    		hour_font_3= null;
    		hour_3 = null;
    		hour_font_4 = null;
    		hour_4 = null;
    		hour_font_6 = null;
    		hour_6 = null;
    		if (hour_font_5 == null) {
	    		hour_font_5 = Ui.loadResource(Rez.Fonts.hour_5);
	    		hour_5 = [[0x213978,0x223994,0x235578],
					[0x243676,0x253692,0x265276,0x276e76],
					[0x283374,0x293390,0x2a4f74,0x2b6b74],
					[0x2c3172,0x2d4d72,0x2e6972],
					[0x2f3070,0x304c70,0x316870],
					[0x32306f,0x334c6f,0x34686f],
					[0x35306a,0x364c6a,0x37686a],
					[0x383163,0x394d63,0x3a6963],
					[0x3b335d,0x3c4f5d,0x3d4f79,0x3e6b5d],
					[0x3f3657,0x405257,0x415273,0x426e57,0x436e73]];
			}
    	} else if (hour_i >= 30){
    		hour_font_1 = null;
    		hour_1 = null;
    		hour_font_2 = null;
    		hour_2 = null;
    		hour_font_3= null;
    		hour_3 = null;
    		hour_font_5 = null;
    		hour_5 = null;
    		hour_font_6 = null;
    		hour_6 = null;
    		if (hour_font_4 == null) {
	    		hour_font_4 = Ui.loadResource(Rez.Fonts.hour_4);
	    		hour_4 = [[0x216f80,0x226f9c,0x236fb8],
					[0x246a7f,0x256a9b,0x266ab7],
					[0x27637f,0x28639b,0x2963b7],
					[0x2a5d7f,0x2b5d9b,0x2c5db7,0x2d797f],
					[0x2e577f,0x2f579b,0x3057b7,0x31737f],
					[0x32517e,0x33519a,0x346d7e],
					[0x354b7e,0x364b9a,0x37677e],
					[0x38467d,0x394699,0x3a627d],
					[0x3b417b,0x3c4197,0x3d5d7b,0x3e5d97],
					[0x3f3d7a,0x403d96,0x41597a]];
			}
    	} else if (hour_i >= 20){
    		hour_font_1 = null;
    		hour_1 = null;
    		hour_font_2 = null;
    		hour_2 = null;
    		hour_font_4= null;
    		hour_4 = null;
    		hour_font_5 = null;
    		hour_5 = null;
    		hour_font_6 = null;
    		hour_6 = null;
    		if (hour_font_3 == null) {
	    		hour_font_3 = Ui.loadResource(Rez.Fonts.hour_3);
	    		hour_3 = [[0x217e78,0x229a78,0x239a94],
					[0x247e7a,0x257e96,0x269a7a,0x279a96],
					[0x287d7b,0x297d97,0x2a997b,0x2b9997],
					[0x2c7b7d,0x2d7b99,0x2e977d,0x2f9799],
					[0x307a7e,0x317a9a,0x32967e,0x33969a],
					[0x34787e,0x35789a,0x36949a],
					[0x37767f,0x38769b,0x39929b,0x3a92b7],
					[0x3b747f,0x3c749b,0x3d74b7,0x3e909b],
					[0x3f727f,0x40729b,0x4172b7],
					[0x42707f,0x43709b,0x4470b7]];
			}
    	} else if (hour_i >= 10){
    		hour_font_1 = null;
    		hour_1 = null;
    		hour_font_3 = null;
    		hour_3 = null;
    		hour_font_4= null;
    		hour_4 = null;
    		hour_font_5 = null;
    		hour_5 = null;
    		hour_font_6 = null;
    		hour_6 = null;
    		if (hour_font_2 == null) {
	    		hour_font_2 = Ui.loadResource(Rez.Fonts.hour_2);
	    		hour_2 = [[0x217e51,0x227e6d,0x239a51],
					[0x247f57,0x257f73,0x269b57,0x27b757],
					[0x287f5d,0x297f79,0x2a9b5d,0x2bb75d],
					[0x2c7f63,0x2d9b63,0x2eb763],
					[0x2f806a,0x309c6a,0x31b86a],
					[0x32806f,0x339c6f,0x34b86f],
					[0x358070,0x369c70,0x37b870],
					[0x387f72,0x399b72,0x3ab772],
					[0x3b7f74,0x3c9b74,0x3d9b90,0x3eb774],
					[0x3f7f76,0x409b76,0x419b92,0x42b792]];
			}
    	} else if (hour_i >= 0){
    		hour_font_2 = null;
    		hour_2 = null;
    		hour_font_3 = null;
    		hour_3 = null;
    		hour_font_4= null;
    		hour_4 = null;
    		hour_font_5 = null;
    		hour_5 = null;
    		hour_font_6 = null;
    		hour_6 = null;
    		if (hour_font_1 == null) {
	    		hour_font_1 = Ui.loadResource(Rez.Fonts.hour_1);
	    		hour_1 = [[0x216f30,0x226f4c,0x236f68],
					[0x247030,0x25704c,0x267068],
					[0x277231,0x28724d,0x297269],
					[0x2a7433,0x2b744f,0x2c746b,0x2d9033],
					[0x2e7636,0x2f7652,0x30766e,0x319236],
					[0x327839,0x337855,0x349439],
					[0x357a3d,0x367a59,0x37963d],
					[0x387b41,0x397b5d,0x3a9741,0x3b975d],
					[0x3c7d47,0x3d7d63,0x3e9947],
					[0x3f7e4b,0x407e67,0x419a4b]];
			}
    	} 
    	
    	
    	var minu_i = getMinuteHandFragment() % 60;
    	if (minu_i >= 50) {
    		minu_font_1 = null;
    		minu_1 = null;
    		minu_font_2 = null;
    		minu_2 = null;
    		minu_font_3 = null;
    		minu_3 = null;
    		minu_font_4 = null;
    		minu_4 = null;
    		minu_font_5 = null;
    		minu_5 = null;
    		if (minu_font_6 == null) {
	    		minu_font_6 = Ui.loadResource(Rez.Fonts.minu_6);
				minu_6 = [[0x212143,0x223d43,0x233d5f,0x24595f],
					[0x25273c,0x26433c,0x274358,0x285f58],
					[0x292d34,0x2a2d50,0x2b4934,0x2c4950,0x2d496c,0x2e6550,0x2f656c],
					[0x30342d,0x313449,0x32502d,0x335049,0x345065,0x356c49,0x366c65],
					[0x373c27,0x383c43,0x395843,0x3a585f],
					[0x3b4421,0x3c443d,0x3d4459,0x3e603d,0x3f6059],
					[0x404c1d,0x414c39,0x424c55,0x436839,0x446855],
					[0x455519,0x465535,0x475551,0x487135,0x497151,0x4a716d],
					[0x4b5e17,0x4c5e33,0x4d5e4f,0x4e5e6b,0x4f7a4f],
					[0x506715,0x516731,0x52674d,0x536769]];
			}
    		
    	} else if (minu_i >= 40) {
    		minu_font_1 = null;
    		minu_1 = null;
    		minu_font_2 = null;
    		minu_2 = null;
    		minu_font_3 = null;
    		minu_3 = null;
    		minu_font_4 = null;
    		minu_4 = null;
    		minu_font_6 = null;
    		minu_6 = null;
    		if (minu_font_5 == null) {
	    		minu_font_5 = Ui.loadResource(Rez.Fonts.minu_5);
	    		minu_5 = [[0x212194,0x223d78,0x233d94,0x245978],
					[0x251d76,0x261d92,0x273976,0x283992,0x295576],
					[0x2a1974,0x2b1990,0x2c3574,0x2d3590,0x2e5174,0x2f6d74],
					[0x301772,0x31178e,0x323372,0x334f72,0x346b72],
					[0x351570,0x363170,0x374d70,0x386970],
					[0x39156f,0x3a316f,0x3b4d6f,0x3c696f],
					[0x3d1567,0x3e3167,0x3f4d67,0x406967],
					[0x41175e,0x42335e,0x434f5e,0x444f7a,0x456b5e],
					[0x461955,0x473555,0x483571,0x495155,0x4a5171,0x4b6d71],
					[0x4c1d4c,0x4d394c,0x4e3968,0x4f554c,0x505568]];
    		}
    	} else if (minu_i >= 30) {
    		minu_font_1 = null;
    		minu_1 = null;
    		minu_font_2 = null;
    		minu_2 = null;
    		minu_font_3 = null;
    		minu_3 = null;
    		minu_font_5 = null;
    		minu_5 = null;
    		minu_font_6 = null;
    		minu_6 = null;
    		if (minu_font_4 == null) {
	    		minu_font_4 = Ui.loadResource(Rez.Fonts.minu_4);
	    		minu_4 = [[0x216f80,0x226f9c,0x236fb8,0x246fd4],
					[0x25677f,0x26679b,0x2767b7,0x2867d3],
					[0x295e7f,0x2a5e9b,0x2b5eb7,0x2c5ed3,0x2d7a7f],
					[0x2e557f,0x2f559b,0x3055b7,0x3155d3,0x32717f,0x33719b],
					[0x344c7f,0x354c9b,0x364cb7,0x37687f,0x38689b],
					[0x39447e,0x3a449a,0x3b44b6,0x3c607e,0x3d609a],
					[0x3e3c9a,0x3f3cb6,0x40587e,0x41589a],
					[0x423499,0x4334b5,0x44507d,0x455099,0x466c7d],
					[0x472d97,0x482db3,0x49497b,0x4a4997,0x4b657b],
					[0x4c2796,0x4d437a,0x4e4396,0x4f5f7a]];
    		}
    	} else if (minu_i >= 20) {
    		minu_font_1 = null;
    		minu_1 = null;
    		minu_font_2 = null;
    		minu_2 = null;
    		minu_font_4 = null;
    		minu_4 = null;
    		minu_font_5 = null;
    		minu_5 = null;
    		minu_font_6 = null;
    		minu_6 = null;
    		if (minu_font_3 == null) {
	    		minu_font_3 = Ui.loadResource(Rez.Fonts.minu_3);
	    		minu_3 = [[0x217e78,0x229a78,0x239a94,0x24b694],
					[0x257e7a,0x267e96,0x279a7a,0x289a96,0x29b696],
					[0x2a7d7b,0x2b7d97,0x2c997b,0x2d9997,0x2e99b3,0x2fb597,0x30b5b3],
					[0x317b7d,0x327b99,0x33977d,0x349799,0x3597b5,0x36b399,0x37b3b5],
					[0x387a7e,0x397a9a,0x3a967e,0x3b969a,0x3c96b6],
					[0x3d787e,0x3e789a,0x3f949a,0x4094b6],
					[0x41767f,0x42769b,0x4376b7,0x44929b,0x4592b7],
					[0x46747f,0x47749b,0x4874b7,0x49909b,0x4a90b7,0x4b90d3],
					[0x4c727f,0x4d729b,0x4e72b7,0x4f72d3,0x508eb7,0x518ed3],
					[0x52707f,0x53709b,0x5470b7,0x5570d3]];
    		}
    	} else if (minu_i >= 10) {
    		minu_font_1 = null;
    		minu_1 = null;
    		minu_font_3 = null;
    		minu_3 = null;
    		minu_font_4 = null;
    		minu_4 = null;
    		minu_font_5 = null;
    		minu_5 = null;
    		minu_font_6 = null;
    		minu_6 = null;
    		if (minu_font_2 == null) {
	    		minu_font_2 = Ui.loadResource(Rez.Fonts.minu_2);
	    		minu_2 = [[0x217e43,0x227e5f,0x239a43,0x249a5f,0x25b643],
					[0x267f4c,0x277f68,0x289b4c,0x299b68,0x2ab74c],
					[0x2b7f55,0x2c7f71,0x2d9b55,0x2e9b71,0x2fb755,0x30d355],
					[0x317f5e,0x327f7a,0x339b5e,0x34b75e,0x35d35e],
					[0x368067,0x379c67,0x38b867,0x39d467],
					[0x3a806f,0x3b9c6f,0x3cb86f,0x3dd46f],
					[0x3e8070,0x3f9c70,0x40b870,0x41d470],
					[0x427f72,0x439b72,0x44b772,0x45b78e,0x46d372,0x47d38e],
					[0x487f74,0x499b74,0x4a9b90,0x4bb774,0x4cb790,0x4dd390],
					[0x4e7f76,0x4f9b76,0x509b92,0x51b776,0x52b792]];
    		}
    	} else if (minu_i >= 0) {
    		minu_font_2 = null;
    		minu_2 = null;
    		minu_font_3 = null;
    		minu_3 = null;
    		minu_font_4 = null;
    		minu_4 = null;
    		minu_font_5 = null;
    		minu_5 = null;
    		minu_font_6 = null;
    		minu_6 = null;
    		if (minu_font_1 == null) {
	    		minu_font_1 = Ui.loadResource(Rez.Fonts.minu_1);
	    		minu_1 = [[0x216f15,0x226f31,0x236f4d,0x246f69],
				[0x257015,0x267031,0x27704d,0x287069],
				[0x297217,0x2a7233,0x2b724f,0x2c726b,0x2d8e17],
				[0x2e7419,0x2f7435,0x307451,0x31746d,0x329019,0x339035],
				[0x34761d,0x357639,0x367655,0x37921d,0x389239],
				[0x39783d,0x3a7859,0x3b9421,0x3c943d],
				[0x3d7a43,0x3e7a5f,0x3f9627,0x409643],
				[0x417b49,0x427b65,0x43972d,0x449749,0x45b32d],
				[0x467d50,0x477d6c,0x489934,0x499950,0x4ab534],
				[0x4b7e58,0x4c9a3c,0x4d9a58,0x4eb63c]];
    		}
    	}
    }
    
//    function checkSecondHandFont() {
//    	var seco_i = getSecondHandFragment() % 60;
//    	if (seco_i >= 50) {
//    		seco_font_1 = null;
//    		seco_1 = null;
//    		seco_font_2 = null;
//    		seco_2 = null;
//    		seco_font_3 = null;
//    		seco_3 = null;
//    		seco_font_4 = null;
//    		seco_4 = null;
//    		seco_font_5 = null;
//    		seco_5 = null;
//    		if (seco_font_6 == null) {
//	    		seco_font_6 = Ui.loadResource(Rez.Fonts.seco_6);
//				seco_6 = [[0x212043,0x223243,0x233255,0x244455,0x255655,0x265667,0x276867],
//					[0x28253b,0x29373b,0x2a374d,0x2b494d,0x2c495f,0x2d5b5f,0x2e5b71,0x2f6d5f,0x306d71],
//					[0x312c33,0x322c45,0x333e33,0x343e45,0x355045,0x365057,0x376257,0x386269],
//					[0x39332c,0x3a333e,0x3b452c,0x3c453e,0x3d4550,0x3e5750,0x3f5762,0x406962],
//					[0x413b25,0x423b37,0x434d37,0x444d49,0x455f49,0x465f5b,0x475f6d,0x48715b,0x49716d],
//					[0x4a4320,0x4b4332,0x4c5532,0x4d5544,0x4e5556,0x4f6756,0x506768],
//					[0x514c1b,0x524c2d,0x534c3f,0x545e2d,0x555e3f,0x565e51,0x575e63,0x587063],
//					[0x595618,0x5a562a,0x5b563c,0x5c683c,0x5d684e,0x5e6860],
//					[0x5f6015,0x606027,0x616039,0x62604b,0x63605d,0x64724b,0x65725d,0x66726f],
//					[0x676a13,0x686a25,0x696a37,0x6a6a49,0x6b6a5b,0x6c6a6d]];
//			}
//    	} else if (seco_i >= 40) {
//    		seco_font_1 = null;
//    		seco_1 = null;
//    		seco_font_2 = null;
//    		seco_2 = null;
//    		seco_font_3 = null;
//    		seco_3 = null;
//    		seco_font_4 = null;
//    		seco_4 = null;
//    		seco_font_6 = null;
//    		seco_6 = null;
//    		if (seco_font_5 == null) {
//	    		seco_font_5 = Ui.loadResource(Rez.Fonts.seco_5);
//	    		seco_5 = [[0x21209d,0x22328b,0x23329d,0x244479,0x25448b,0x265679,0x27568b,0x286879],
//					[0x291b8a,0x2a1b9c,0x2b2d8a,0x2c3f78,0x2d3f8a,0x2e5178,0x2f518a,0x306378],
//					[0x311889,0x322a89,0x333c77,0x343c89,0x354e77,0x366077],
//					[0x371576,0x381588,0x392776,0x3a2788,0x3b3976,0x3c4b76,0x3d5d76,0x3e6f76],
//					[0x3f1375,0x402575,0x413775,0x424975,0x435b75,0x446d75],
//					[0x451374,0x462574,0x473774,0x484974,0x495b74,0x4a6d74],
//					[0x4b136a,0x4c256a,0x4d376a,0x4e496a,0x4f5b6a,0x506d6a],
//					[0x511560,0x522760,0x533960,0x544b60,0x554b72,0x565d60,0x575d72,0x586f72],
//					[0x591856,0x5a2a56,0x5b3c56,0x5c3c68,0x5d4e68,0x5e6068],
//					[0x5f1b4c,0x602d4c,0x612d5e,0x623f4c,0x633f5e,0x64515e,0x65635e,0x666370]];
//			}
//    	} else if (seco_i >= 30){
//    		seco_font_1 = null;
//    		seco_1 = null;
//    		seco_font_2 = null;
//    		seco_2 = null;
//    		seco_font_3 = null;
//    		seco_3 = null;
//    		seco_font_5 = null;
//    		seco_5 = null;
//    		seco_font_6 = null;
//    		seco_6 = null;
//    		if (seco_font_4 == null) {
//	    		seco_font_4 = Ui.loadResource(Rez.Fonts.seco_4);
//	    		seco_4 = [[0x21747e,0x227490,0x2374a2,0x2474b4,0x2574c6,0x2674d8],
//					[0x276a7e,0x286a90,0x296aa2,0x2a6ab4,0x2b6ac6,0x2c6ad8],
//					[0x2d607e,0x2e6090,0x2f60a2,0x3060b4,0x3160c6,0x3260d8,0x33727e,0x347290],
//					[0x3556a1,0x3656b3,0x3756c5,0x38687d,0x39688f,0x3a68a1],
//					[0x3b4ca1,0x3c4cb3,0x3d4cc5,0x3e5e7d,0x3f5e8f,0x405ea1,0x415eb3,0x42707d],
//					[0x4343a1,0x4443b3,0x4543c5,0x46558f,0x4755a1,0x4855b3,0x49677d,0x4a678f],
//					[0x4b3ba0,0x4c3bb2,0x4d3bc4,0x4e4d8e,0x4f4da0,0x504db2,0x515f7c,0x525f8e,0x53717c],
//					[0x54339f,0x5533b1,0x56458d,0x57459f,0x5845b1,0x59577b,0x5a578d,0x5b697b],
//					[0x5c2c9f,0x5d2cb1,0x5e3e8d,0x5f3e9f,0x60507b,0x61508d,0x62627b,0x63628d],
//					[0x64259e,0x6525b0,0x66378c,0x67379e,0x68497a,0x69498c,0x6a5b7a,0x6b5b8c,0x6c6d7a]];
//			}
//    	} else if (seco_i >= 20){
//    		seco_font_1 = null;
//    		seco_1 = null;
//    		seco_font_2 = null;
//    		seco_2 = null;
//    		seco_font_4 = null;
//    		seco_4 = null;
//    		seco_font_5 = null;
//    		seco_5 = null;
//    		seco_font_6 = null;
//    		seco_6 = null;
//    		if (seco_font_3 == null) {
//	    		seco_font_3 = Ui.loadResource(Rez.Fonts.seco_3);
//	    		seco_3 = [[0x217d79,0x228f79,0x238f8b,0x24a18b,0x25b38b,0x26b39d,0x27c59d],
//					[0x287c7a,0x298e7a,0x2a8e8c,0x2ba08c,0x2ca09e,0x2db29e,0x2eb2b0,0x2fc49e,0x30c4b0],
//					[0x317b7b,0x328d7b,0x338d8d,0x349f8d,0x359f9f,0x36b19f,0x37b1b1],
//					[0x387b7b,0x397b8d,0x3a8d8d,0x3b8d9f,0x3c9f9f,0x3d9fb1,0x3eb1b1],
//					[0x3f7a7c,0x407a8e,0x418c8e,0x428ca0,0x439ea0,0x449eb2,0x459ec4,0x46b0b2,0x47b0c4],
//					[0x48797d,0x49798f,0x4a8b8f,0x4b8ba1,0x4c8bb3,0x4d9db3,0x4e9dc5],
//					[0x4f787d,0x50788f,0x5178a1,0x528a8f,0x538aa1,0x548ab3,0x558ac5,0x569cc5],
//					[0x57777d,0x58778f,0x5977a1,0x5a89a1,0x5b89b3,0x5c89c5],
//					[0x5d767e,0x5e7690,0x5f76a2,0x6076b4,0x6176c6,0x6288b4,0x6388c6,0x6488d8],
//					[0x65757e,0x667590,0x6775a2,0x6875b4,0x6975c6,0x6a75d8]];
//			}
//    	} else if (seco_i >= 10){
//    		seco_font_1 = null;
//    		seco_1 = null;
//    		seco_font_3 = null;
//    		seco_3 = null;
//    		seco_font_4 = null;
//    		seco_4 = null;
//    		seco_font_5 = null;
//    		seco_5 = null;
//    		seco_font_6 = null;
//    		seco_6 = null;
//    		if (seco_font_2 == null) {
//	    		seco_font_2 = Ui.loadResource(Rez.Fonts.seco_2);
//	    		seco_2 = [[0x217d67,0x228f55,0x238f67,0x24a143,0x25a155,0x26b343,0x27b355,0x28c543],
//					[0x297d5e,0x2a7d70,0x2b8f5e,0x2ca14c,0x2da15e,0x2eb34c,0x2fb35e,0x30c54c],
//					[0x317d68,0x328f68,0x33a156,0x34a168,0x35b356,0x36c556],
//					[0x377e60,0x387e72,0x399060,0x3a9072,0x3ba260,0x3cb460,0x3dc660,0x3ed860],
//					[0x3f7e6a,0x40906a,0x41a26a,0x42b46a,0x43c66a,0x44d86a],
//					[0x457e74,0x469074,0x47a274,0x48b474,0x49c674,0x4ad874],
//					[0x4b7e75,0x4c9075,0x4da275,0x4eb475,0x4fc675,0x50d875],
//					[0x517e76,0x529076,0x53a276,0x54b476,0x55b488,0x56c676,0x57c688,0x58d888],
//					[0x597d77,0x5a8f77,0x5ba177,0x5ca189,0x5db389,0x5ec589],
//					[0x5f7d78,0x608f78,0x618f8a,0x62a178,0x63a18a,0x64b38a,0x65c58a,0x66c59c]];
//			}
//    	} else {
//    		seco_font_2 = null;
//    		seco_2 = null;
//    		seco_font_3 = null;
//    		seco_3 = null;
//    		seco_font_4 = null;
//    		seco_4 = null;
//    		seco_font_5 = null;
//    		seco_5 = null;
//    		seco_font_6 = null;
//    		seco_6 = null;
//    		if (seco_font_1 == null) {
//	    		seco_font_1 = Ui.loadResource(Rez.Fonts.seco_1);
//	    		seco_1 = [[0x217413,0x227425,0x237437,0x247449,0x25745b,0x26746d],
//					[0x277513,0x287525,0x297537,0x2a7549,0x2b755b,0x2c756d],
//					[0x2d7615,0x2e7627,0x2f7639,0x30764b,0x31765d,0x32766f,0x338815,0x348827],
//					[0x35773c,0x36774e,0x377760,0x388918,0x39892a,0x3a893c],
//					[0x3b783f,0x3c7851,0x3d7863,0x3e8a1b,0x3f8a2d,0x408a3f,0x418a51,0x429c1b],
//					[0x437944,0x447956,0x457968,0x468b32,0x478b44,0x488b56,0x499d20,0x4a9d32],
//					[0x4b7a49,0x4c7a5b,0x4d7a6d,0x4e8c37,0x4f8c49,0x508c5b,0x519e25,0x529e37,0x53b025],
//					[0x547b50,0x557b62,0x568d3e,0x578d50,0x588d62,0x599f2c,0x5a9f3e,0x5bb12c],
//					[0x5c7b57,0x5d7b69,0x5e8d45,0x5f8d57,0x609f33,0x619f45,0x62b133,0x63b145],
//					[0x647c5f,0x657c71,0x668e4d,0x678e5f,0x68a03b,0x69a04d,0x6ab23b,0x6bb24d,0x6cc43b]];
//			}
//    	}
//    }
    
    function draw(dc) {
//    	var start = System.getTimer();
    	
    	checkCurrentFont();
    	
    	if (Application.getApp().getProperty("use_analog") == false) {
    		return;
    	}
    	
		draw_analog_hands(dc);
		
//		var end = System.getTimer();
//        System.println("analogue draw " + (end-start) + "ms");
    }
    
    function draw_analog_hands(dc) {

		dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
    	drawHandAntiAlias(dc);
    	second_x = centerX;
	    second_y  = centerY - second_font_height_half*2;
    	
    	if (secondHandDisabled) {
    		return;
    	}
    	
    	// no second hand in power save mode
    	if (Application.getApp().getProperty("power_save_mode")) {
    		return;
    	}
    	
        dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
        drawSecondHand(dc);
    	
    }
    
    /////////////////////////
    /// antialias handler ///
    /////////////////////////
    
    function drawHandAntiAlias(dc) {
    	var hour_i = getHourHandFragment() % 60;
    	if (hour_i >= 50) {
    		drawTiles(hour_6[(hour_i - 50).toNumber()], hour_font_6, dc, hour_i);
    	} else if (hour_i >= 40) {
    		drawTiles(hour_5[(hour_i - 40).toNumber()], hour_font_5, dc, hour_i);
    	} else if (hour_i >= 30) {
    		drawTiles(hour_4[(hour_i - 30).toNumber()], hour_font_4, dc, hour_i);
    	} else if (hour_i >= 20) {
    		drawTiles(hour_3[(hour_i - 20).toNumber()], hour_font_3, dc, hour_i);
    	} else if (hour_i >= 10) {
    		drawTiles(hour_2[(hour_i - 10).toNumber()], hour_font_2, dc, hour_i);
    	} else {
    		drawTiles(hour_1[hour_i.toNumber()], hour_font_1, dc, hour_i);
    	}
    	
    	var minu_i = getMinuteHandFragment() % 60;
    	if (minu_i >= 50) {
    		drawTiles(minu_6[(minu_i - 50).toNumber()], minu_font_6, dc, minu_i);
    	} else if (minu_i >= 40) {
    		drawTiles(minu_5[(minu_i - 40).toNumber()], minu_font_5, dc, minu_i);
    	} else if (minu_i >= 30) {
    		drawTiles(minu_4[(minu_i - 30).toNumber()], minu_font_4, dc, minu_i);
    	} else if (minu_i >= 20) {
    		drawTiles(minu_3[(minu_i - 20).toNumber()], minu_font_3, dc, minu_i);
    	} else if (minu_i >= 10) {
    		drawTiles(minu_2[(minu_i - 10).toNumber()], minu_font_2, dc, minu_i);
    	} else {
    		drawTiles(minu_1[minu_i.toNumber()], minu_font_1, dc, minu_i);
    	}
    }
    
    function drawSecondHand(dc) {
        var base_radius = centerX==109 ? 0.0 : 11.0;
        var minu_radius = centerX-23.0;
        var base_thick = 3.0;
        var radian = 2*(getSecondHandFragment()/60.0)*Math.PI;

        var startx = convertCoorX(radian, base_radius);
        var starty = convertCoorY(radian, base_radius);
        var endx = convertCoorX(radian, minu_radius);
        var endy = convertCoorY(radian, minu_radius);

        dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(base_thick);
        dc.drawLine(startx, starty, endx, endy);
    }

//    function drawSecondHandAntiAlias(dc) {
//    	checkSecondHandFont();
//    	
//    	dc.setColor(secondHandColor, Graphics.COLOR_TRANSPARENT);
//    	var seco_i = getSecondHandFragment() % 60;
//    	if (seco_i >= 50) {
//    		drawTiles(seco_6[(seco_i - 50).toNumber()], seco_font_6, dc, seco_i);
//    	} else if (seco_i >= 40) {
//    		drawTiles(seco_5[(seco_i - 40).toNumber()], seco_font_5, dc, seco_i);
//    	} else if (seco_i >= 30) {
//    		drawTiles(seco_4[(seco_i - 30).toNumber()], seco_font_4, dc, seco_i);
//    	} else if (seco_i >= 20) {
//    		drawTiles(seco_3[(seco_i - 20).toNumber()], seco_font_3, dc, seco_i);
//    	} else if (seco_i >= 10) {
//    		drawTiles(seco_2[(seco_i - 10).toNumber()], seco_font_2, dc, seco_i);
//    	} else {
//    		drawTiles(seco_1[(seco_i).toNumber()], seco_font_1, dc, seco_i);
//    	}
//    	
//    	seco_font_1 = null;
//		seco_1 = null;
//		seco_font_2 = null;
//		seco_2 = null;
//		seco_font_3 = null;
//		seco_3 = null;
//		seco_font_4 = null;
//		seco_4 = null;
//		seco_font_5 = null;
//		seco_5 = null;
//		seco_font_6 = null;
//		seco_6 = null;
//    }
    
    function drawTiles(packed_array,font,dc,index) {
      var radian = (index.toFloat()/60.0)*(2*3.1415) - 0.5*3.1415;
      var offset_rad_x = convertCoorX(radian, offset_rad)-centerX;
      var offset_rad_y = convertCoorY(radian, offset_rad)-centerY;
      for(var i = 0; i < packed_array.size(); i++) {
      	var val = packed_array[i];
		var char = (val >> 16) & 255;
		var xpos = (val >> 8) & 255;
		var ypos = (val >> 0) & 255;
        dc.drawText((xpos+offset_x-offset_rad_x).toNumber(),(ypos+offset_y-offset_rad_y).toNumber(),font,char.toNumber().toChar(),Graphics.TEXT_JUSTIFY_LEFT);
      }
    }
    
    hidden function degreesToRadians(degrees) {
    	return degrees * Math.PI / 180;
    }  
    
    hidden function radiansToDegrees(radians) {
    	return radians * 180 / Math.PI;
    }  
    
    hidden function convertCoorX(radians, radius) {
		return centerX + radius*Math.cos(radians);
    }
    
    hidden function convertCoorY(radians, radius) {
		return centerY + radius*Math.sin(radians);
    }
    
    private function getHourHandFragment() {    	
    	var clockTime = System.getClockTime();        		
    	var hour = clockTime.hour;
		var minute = clockTime.min;		
		return (((hour*60.0+minute) / (12.0*60))*60.0).toLong();
    }
    
    private function getMinuteHandFragment() {   
    	var clockTime = System.getClockTime(); 
		return clockTime.min.toLong();
	} 	
    
    private function getSecondHandFragment() {   
    	var clockTime = System.getClockTime(); 
		return clockTime.sec.toLong();
	} 
    
//    private function getHourHandFragment() {    	
//    	var clockTime = System.getClockTime();        		
//    	var hour = clockTime.hour;
//		var minute = clockTime.min;
//		return (((hour%12)*60.0+minute.toLong()) / (12.0*60.0));
//    }
//    
//    private function getMinuteHandFragment() {   
//    	var clockTime = System.getClockTime(); 
//		return clockTime.min.toLong()/60.0;
//	} 	
//    
//    private function getSecondHandFragment() {   
//    	var clockTime = System.getClockTime(); 
//		return clockTime.sec.toLong()/60.0;
//	} 
}