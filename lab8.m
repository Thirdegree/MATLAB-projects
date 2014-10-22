function [] = lab8()
	global key;
	InitKeyboard();
	
	left = NXTMotor('A');
	right = NXTMotor('B');
	OpenUltrasonic(SENSOR_2);
	OpenLight(SENSOR_1, 'ACTIVE');
	OpenLight(SENSOR_3, 'ACTIVE');
	OpenLight(SENSOR_4, 'ACTIVE');
	
	function [] = forward()
		left.Power = -24;
		right.Power = -24;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function[] = run()
		left.Power = -70;
		right.Power = -70;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function [] = backward()
		left.Power = 100;
		right.Power = 100;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function [] = goLeft()
		left.Power = 0;
		right.Power = 100;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function [] = goRight()
		left.Power = 100;
		right.Power = 0;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function [] = stop()
		left.Power = 0;
		right.Power = 0;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function [] = scared()
		is_scared = false;
		while (GetLight(SENSOR_1) < 350) || (GetLight(SENSOR_3) <350)
			run()
			is_scared = true;
		end
		if is_scared
			pause(1.0);
		end
		stop();
	end
			
	function [] = pivot()
		left.Power = 50;
		right.Power = -50;
		left.SendToNXT();
		right.SendToNXT();
	end
	
	function [] = seek()
		while ((GetUltrasonic(SENSOR_2)>30) &&  are_being_attacked() == false)
			pivot();
		end
		destroy();
	end
	
	function [y] = are_being_attacked()
		y = ((GetLight(SENSOR_1) < 350) || (GetLight(SENSOR_3) <350));
	end
	
	function [] = destroy()
		while GetUltrasonic(SENSOR_2) < 50
			run();
		end
	end
	
	function [] = evade()
		right.TachoLimit = 360*4;
		goLeft();
		right.WaitFor();
		right.TachoLimit = 0;
	end
	
	function[] = retreat()
		in_retreat = false;
		while GetLight(SENSOR_4) < 350
			backward();
			in_retreat = true;
		end
		if in_retreat
			pause(1.0);
		end
		stop();
	end
	
	while (1)
		scared();
		retreat();
		switch key
			case 'uparrow'
				forward();
			case 'downarrow'
				backward();
			case 'leftarrow'
				goLeft();
			case 'rightarrow'
				goRight();
			case 0
				seek();
			case 'z'
				evade();
			case 'q'
				break;
		end
	end
				
	CloseSensor(SENSOR_1);
	CloseSensor(SENSOR_2);
	CloseSensor(SENSOR_3);
	left.Stop('off');
	right.Stop('off');
	CloseKeyboard();
end
	