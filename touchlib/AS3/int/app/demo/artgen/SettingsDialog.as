package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import app.demo.artgen.*;
	import app.core.element.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.text.*;
	import flash.geom.*;
	
	public class SettingsDialog extends MovieClip 
	{
		var swarmTypes:Array;
		var shapes:Array;
		var modDests:Array;
		private var lfoShapes:Array;
		
		private var swarmType:ScrollList;
		private var swarmNumber:HorizontalSlider;
		private var shapeType:ScrollList;		
		private var scaleSlider:HorizontalSlider;				
		private var alphaSlider:HorizontalSlider;						
		private var lifeSlider:HorizontalSlider;
		private var speedSlider:HorizontalSlider;		
		private var turnSlider:HorizontalSlider;
		private var delaySlider:HorizontalSlider;
		private var scaleDecaySlider:HorizontalSlider;
		private var alphaDecaySlider:HorizontalSlider;		
		private var doneBtnHolder:TouchlibWrapper;
		
		private var lfo1Type:ScrollList;
		private var lfo1Rate:HorizontalSlider;
		private var lfo1Dest:ScrollList;
		private var lfo1Amount:HorizontalSlider;		
		
		private var lfo2Type:ScrollList;
		private var lfo2Rate:HorizontalSlider;
		private var lfo2Dest:ScrollList;
		private var lfo2Amount:HorizontalSlider;				
		
		private var colorPicker_0:ColorPicker;
	
		private var settings:XML;
		private var Main:ArtGenMain;
		
		private var curX:int = 0;
		private var curY:int = 0;
		
		public function SettingsDialog(s:XML, m:ArtGenMain) 
		{
			settings = s;
			Main = m;
			

			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.font = "Neo Tech Std";
			tf.size = "16";					
			
			var num:Number;
			
			swarmTypes = new Array();			
			swarmTypes.push("LazyFollower");			
			swarmTypes.push("HoppingBugs");	
			swarmTypes.push("Boid");
			swarmTypes.push("Boid2");			
			
			shapes = new Array();
			shapes.push("Shape1.swf");
			shapes.push("Shape2.swf");
			shapes.push("Shape3.swf");
			shapes.push("Shape4.swf");
			shapes.push("Shape5.swf");
			shapes.push("Shape6.swf");
			shapes.push("Shape7.swf");
			shapes.push("Shape8.swf");
			shapes.push("Shape9.swf");
			shapes.push("Shape10.swf");	
			shapes.push("Shape11.swf");	
			shapes.push("Shape12.swf");	
			shapes.push("Shape13.swf");	
			shapes.push("Shape14.swf");				
			
			
			modDests = new Array();
			modDests.push("nothing");
			modDests.push("alpha");
			modDests.push("scale");
			modDests.push("position");
			
			lfoShapes = new Array();
			lfoShapes.push("sine");
			lfoShapes.push("square");
			lfoShapes.push("random");
			
			var lab:TextField;
			swarmType = new ScrollList(swarmTypes);
			swarmType.y = curY;
			swarmType.x = 100;
			swarmType.setSelected(settings.swarmType);
			lab = new TextField();
			lab.defaultTextFormat = tf;
			lab.text = "SWARM TYPE";
			lab.y = 10;
			lab.x = -100;
			swarmType.addChild(lab);
			curY += 75;
			addChild(swarmType);
			
			swarmNumber = new HorizontalSlider(200, 40);
			swarmNumber.y = curY;
			swarmNumber.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SWARM MEMBERS";
			lab.y = 10;
			lab.x = -100;
			swarmNumber.addChild(lab);			
			curY += 60;
			swarmNumber.setValue((settings.numMembers - 1) / 9.0);			
			addChild(swarmNumber);
			
			shapeType = new ScrollList(shapes);
			shapeType.y = curY;
			shapeType.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SHAPE";
			lab.y = 10;
			lab.x = -100;
			shapeType.addChild(lab);						
			shapeType.setSelected(settings.shape);						
			curY += 75;
			addChild(shapeType);
			
			scaleSlider = new HorizontalSlider(200, 40);
			scaleSlider.y = curY;
			scaleSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SCALE";
			lab.y = 10;
			lab.x = -100;
			scaleSlider.addChild(lab);									
			scaleSlider.setValue(settings.scale);			
			curY += 60;
			addChild(scaleSlider);			
			
			alphaSlider = new HorizontalSlider(200, 40);
			alphaSlider.y = curY;
			alphaSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "ALPHA";
			lab.y = 10;
			lab.x = -100;
			alphaSlider.addChild(lab);									
			alphaSlider.setValue(settings.alpha);
			curY += 60;
			addChild(alphaSlider);						
			
			turnSlider = new HorizontalSlider(200, 40);
			turnSlider.y = curY;
			turnSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "TURN";
			lab.y = 10;
			lab.x = -100;
			turnSlider.addChild(lab);									
			turnSlider.setValue(settings.algorithm.turnRate);
			curY += 60;
			addChild(turnSlider);									
			
			speedSlider = new HorizontalSlider(200, 40);
			speedSlider.y = curY;
			speedSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SPEED";
			lab.y = 10;
			lab.x = -100;
			speedSlider.addChild(lab);									
			speedSlider.setValue(settings.algorithm.speed);
			curY += 60;
			addChild(speedSlider);												
			
			lifeSlider = new HorizontalSlider(200, 40);
			lifeSlider.y = curY;
			lifeSlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LIFE";
			lab.y = 10;
			lab.x = -100;
			lifeSlider.addChild(lab);									
			lifeSlider.setValue(settings.trail.lifeTime/10000.0);
			curY += 60;
			addChild(lifeSlider);						
			
			delaySlider = new HorizontalSlider(200, 40);
			delaySlider.y = curY;
			delaySlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "CREATE DELAY";
			lab.y = 10;
			lab.x = -100;
			delaySlider.addChild(lab);									
			delaySlider.setValue(settings.trail.createDelay/7.0);
			curY += 60;
			addChild(delaySlider);			
			
			scaleDecaySlider = new HorizontalSlider(200, 40);
			scaleDecaySlider.y = curY;
			scaleDecaySlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "SCALE DECAY";
			lab.y = 10;
			lab.x = -100;
			scaleDecaySlider.addChild(lab);									
			num = settings.trail.scaleDecay
			scaleDecaySlider.setValue((num + 0.1) / 0.2 );
			curY += 60;
			addChild(scaleDecaySlider);						
			
			alphaDecaySlider = new HorizontalSlider(200, 40);
			alphaDecaySlider.y = curY;
			alphaDecaySlider.x = 100;
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "ALPHA DECAY";
			lab.y = 10;
			lab.x = -100;
			alphaDecaySlider.addChild(lab);									
			num = settings.trail.alphaDecay
			alphaDecaySlider.setValue((num + 0.1) / 0.2 );
			curY += 60;
			addChild(alphaDecaySlider);									
			
			
			
			lfo1Type = new ScrollList(lfoShapes);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO1 Shape";
			lab.y = 10;
			lab.x = -100;
			lfo1Type.addChild(lab);						
			lfo1Type.setSelected(settings.modulators.modulator[0].type);						
			addChild(lfo1Type);			
			
			lfo1Rate = new HorizontalSlider(200, 40);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO1 Rate";
			lab.y = 10;
			lab.x = -100;
			lfo1Rate.addChild(lab);									
			lfo1Rate.setValue(settings.modulators.modulator[0].rate);
			addChild(lfo1Rate);												
			
			lfo1Dest = new ScrollList(modDests);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO1 Dest";
			lab.y = 10;
			lab.x = -100;
			lfo1Dest.addChild(lab);						
			lfo1Dest.setSelected(settings.modulators.modulator[0].dest);						
			addChild(lfo1Dest);						
			
			lfo1Amount = new HorizontalSlider(200, 40);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO1 Amount";
			lab.y = 10;
			lab.x = -100;
			lfo1Amount.addChild(lab);									
			lfo1Amount.setValue(settings.modulators.modulator[0].amount);
			addChild(lfo1Amount);															
			
			
			lfo2Type = new ScrollList(lfoShapes);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO2 Shape";
			lab.y = 10;
			lab.x = -100;
			lfo2Type.addChild(lab);						
			lfo2Type.setSelected(settings.modulators.modulator[1].type);						
			addChild(lfo2Type);			
			
			lfo2Rate = new HorizontalSlider(200, 40);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO2 Rate";
			lab.y = 10;
			lab.x = -100;
			lfo2Rate.addChild(lab);									
			lfo2Rate.setValue(settings.modulators.modulator[1].rate);
			addChild(lfo2Rate);												
			
			lfo2Dest = new ScrollList(modDests);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO2 Dest";
			lab.y = 10;
			lab.x = -100;
			lfo2Dest.addChild(lab);						
			lfo2Dest.setSelected(settings.modulators.modulator[1].dest);						
			addChild(lfo2Dest);						
			
			lfo2Amount = new HorizontalSlider(200, 40);
			lab = new TextField();
			lab.defaultTextFormat = tf;			
			lab.text = "LFO2 Amount";
			lab.y = 10;
			lab.x = -100;
			lfo2Amount.addChild(lab);									
			lfo2Amount.setValue(settings.modulators.modulator[1].amount);
			addChild(lfo2Amount);																		
			
			colorPicker_0 = new ColorPicker();
			colorPicker_0.x = 600;
			colorPicker_0.y = 500;			
			addChild(colorPicker_0);
			
			var donebtn:SimpleButton = new DoneButton();					
			
			// FIXME: need a cancel button.
			doneBtnHolder = new TouchlibWrapper(donebtn);
			doneBtnHolder.x = 600;
			doneBtnHolder.y = 450;			
			doneBtnHolder.addEventListener(MouseEvent.CLICK, doneClicked);
			addChild(doneBtnHolder);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			
		}
		
		private function nextCtrl(ctrl:DisplayObject, ht:int)
		{
			ctrl.x = curX;
			ctrl.y = curY;
			curY += ht;
			
			if(curY >= stage.stageHeight - ht)
			{
				curY = 5;
				curX += 330;
			}
		}
		public function addedToStageHandler(e:Event)
		{
			stage.addEventListener(Event.RESIZE, resized);
			resized(new Event("Resized"));
		}
		
		public function resized(e:Event)
		{
			graphics.clear();
			graphics.beginFill(0x000000, 0.8);
			graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			curX = 100;
			curY = 5;
			nextCtrl(swarmType, 70);
			nextCtrl(swarmNumber, 55);
			nextCtrl(shapeType, 70);
			nextCtrl(scaleSlider, 55);
			nextCtrl(alphaSlider, 55);
			nextCtrl(turnSlider, 55);
			nextCtrl(speedSlider, 55);
			nextCtrl(lifeSlider, 55);
			nextCtrl(delaySlider, 55);
			nextCtrl(scaleDecaySlider, 55);
			nextCtrl(alphaDecaySlider, 55);					
			nextCtrl(lfo1Type, 70);
			nextCtrl(lfo1Rate, 55);
			nextCtrl(lfo1Dest, 70);
			nextCtrl(lfo1Amount, 55);
			nextCtrl(lfo2Type, 70);
			nextCtrl(lfo2Rate, 55);
			nextCtrl(lfo2Dest, 70);
			nextCtrl(lfo2Amount, 125);			
			
			nextCtrl(colorPicker_0, 350);						
			
			nextCtrl(doneBtnHolder, 55);								

		}
		
		public function doneClicked(e:Event)
		{
			this.visible = false;
			Main.applySettings();
		}
		
		
		public function getXML():XML
		{
			settings.scale = scaleSlider.getValue();
			settings.alpha = alphaSlider.getValue();			
			settings.shape = shapeType.getSelected();			
			settings.swarmType = swarmType.getSelected();						
			settings.numMembers = int((swarmNumber.getValue()*9.0) + 1.0);
			settings.trail.lifeTime = lifeSlider.getValue()*10000;			
			settings.trail.createDelay = int(delaySlider.getValue()*7.0);
			settings.trail.scaleDecay = ((scaleDecaySlider.getValue()*0.2) - 0.1) ;			
			settings.trail.alphaDecay = ((alphaDecaySlider.getValue()*0.2) - 0.1) ;			
			settings.modulators.modulator[0].type = lfo1Type.getSelected();
			settings.modulators.modulator[0].rate = lfo1Rate.getValue()*20.0;			
			settings.modulators.modulator[0].dest = lfo1Dest.getSelected();			
			settings.modulators.modulator[0].amount = lfo1Amount.getValue();
			
			settings.modulators.modulator[1].type = lfo2Type.getSelected();
			settings.modulators.modulator[1].rate = lfo2Rate.getValue()*20.0;			
			settings.modulators.modulator[1].dest = lfo2Dest.getSelected();			
			settings.modulators.modulator[1].amount = lfo2Amount.getValue();			
			settings.color = colorPicker_0.color;
			return settings;
		}
	}
}