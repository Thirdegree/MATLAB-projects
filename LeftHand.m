function [] = LeftHand()
    left = NXTMotor('C');
    right = NXTMotor('B');
    
    ultra = SENSOR_1;
    OpenUltrasonic(SENSOR_1);
    
    touch = SENSOR_2;
    OpenSwitch(SENSOR_2);
    
    while 1
        left.SendToNXT();
        right.SendToNXT();
        leftValue = 100;
        rightValue = 100;
        if GetSwitch(touch) == 1
            leftValue = -100;
            rightValue = -100;
            pause(0.5);
            if GetUltrasonic(ultra) < 12
                leftValue = 0;
                rightValue = -100;
            else
                leftValue = -100;
                rightValue = 0;
            end
        end
        left.Power = -leftValue;
        right.Power = -0.9*rightValue;
    end
