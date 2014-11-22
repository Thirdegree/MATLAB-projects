function [] = Lab10b()
	global key;
	InitKeyboard();

	% Motors used for moving the bot.
	left = NXTMotor('C');
    right = NXTMotor('B');
    both = NXTMotor('BC');

    % Motor used for pivoting the ultrasonic sensor, not sure about this.
    pivotMotor = NXTMotor('A');
    
    % So that the sensors can easily be changed.
    ultra = SENSOR_1;
    bumper = SENSOR_2;
    
    % opens sensors
    OpenUltrasonic(ultra);
    OpenSwitch(bumper);

    % TachoLimit for a 90 degree turn, in theory.
    nintyDegree = 200;

    % Moves forward with a slight bias towards the right side. 
    function [] = forwardRight()
    	left.Power = -100;
    	right.Power = -80;
    	both.SendToNXT();
    end

    % Moves forward with a slight bias towards the left side.
    function [] = forwardLeft()
    	left.Power = -80;
    	right.Power = -100;
    	both.SendToNXT();
    end

    % Backs up, and turns 90 degrees to the left
    function [] = intoWall()
    	backward();
    	pause(0.5);
    	turnLeft();
    end

    % self explaitory.
    function [] = backward()
    	both.Power = 100;
    	both.SendToNXT();
    end

    % While it's moving along a wall, it tries to stay at 40 cm for the right wall
    % If it hits a wall, it does intoWall()
    % If I hit 'q', it stops.
    keepDistance = 40
    function [] = main() 
    	while (GetUltrasonic(ultra)<keepDistance) && ~GetSwitch(bumper) && (key ~= 'q')
    		forwardLeft();
    	end

    	while (GetUltrasonic(ultra)>=keepDistance) && ~GetSwitch(bumper) && (key ~= 'q')
    		forwardRight();
    	end

    	if GetSwitch(bumper)
    		intoWall();
    	end

    end

    % Main loop
    while (1) && (key ~= 'q')
    	main();
    end

    % Ending things nicely.
    CloseSensor(ultra);
    CloseSensor(bumper);
    both.Stop('off');
    pivotMotor.Stop('off');
end