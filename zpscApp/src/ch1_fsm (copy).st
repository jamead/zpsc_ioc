/* Sequencer to control the on-demond record process: ramping table download, power supply mode change, and watch funciton upload */

#define PRINTF seqLog

program ch1_fsm ("M0=lab{3}Chan1")

/* options */
option  +r;
option  -c; 



/*Write Only PV's*/
//short Park; assign Park to "{M0}:DigOut_Park-SP"; monitor Park;
short Park; assign Park to "{M0}:DigOut_Park-SP"; monitor Park;
short on_cmd; assign on_cmd to "{M0}:DigOut_ON1-SP"; monitor on_cmd;
short ch1_dac_setpoint; assign ch1_dac_setpoint to "{M1}I-sp"; monitor ch1_dac_setpoint;  
short on1_cmd; assign on1_cmd to "{M0}:On1-Cmd"; monitor on1_cmd;
short ch1_clr_flts; assign ch1_clr_flts to "{M2}FltClearChan1-bo"; monitor ch1_clr_flts; 
short ch1_mode; assign ch1_mode to "{M1}Mode-cmd"; monitor ch1_mode; 
short ch1_ps_on_off_sts; assign ch1_ps_on_off_sts to "{M0}:PsOnOff-Sts"; monitor ch1_ps_on_off_sts; 

/*Read Only PV's*/
short ch1_dac_rdbck; assign ch1_dac_rdbck to "{M0}-DAC-SP"; monitor ch1_dac_rdbck; 
short ch1_ps_sts; assign ch1_ps_sts to "{M0}:Status0"; monitor ch1_ps_sts; 

/* stringout to display status or progress. */
string Chan1_seq_messages;  assign Chan1_seq_messages to "Chan1_seq_messages";

ss OFF_ON_FSM {
	state INIT {
		when(){
		   Park =0; 
		   pvPut(Park);
		   on1_cmd = 0; 
		   pvPut(on1_cmd); 
		   ch1_mode = 0; 
		   pvPut(ch1_mode); 
		   sprintf(Chan1_seq_messages, "PS OFF");
        	   pvPut(Chan1_seq_messages);
        	   ch1_ps_on_off_sts = 1; 
		   pvPut(ch1_ps_on_off_sts); 
		  } state IDLE
	} 
	state IDLE {
		when (on_cmd==1) {
			Park = 1; 
			pvPut(Park);
			ch1_ps_on_off_sts = 0; 
			pvPut(ch1_ps_on_off_sts); 
			sprintf(Chan1_seq_messages, "Zero DAC");
        	   	pvPut(Chan1_seq_messages);
        	   	ch1_dac_setpoint =0.0; 
        	   	pvPut(ch1_dac_setpoint); 
		} state WAIT_FOR_DAC_CHANGE_ON
			
	}
	state WAIT_FOR_DAC_CHANGE_ON {
		when (delay(3)) {
		} state SET_DAC_TO_ZERO_ON
	}
	state SET_DAC_TO_ZERO_ON {
		when ((ch1_dac_rdbck < 0.01) && (ch1_dac_rdbck > -0.01)) {
			sprintf(Chan1_seq_messages, "Zero DAC");
			pvPut(Chan1_seq_messages);  
			ch1_dac_setpoint =0.000; 
        	   	pvPut(ch1_dac_setpoint); 						
		} state POWER_ON
	}
	state POWER_ON {
		when (delay(4)) {
			Park = 1; 
			pvPut(Park); 
		        ch1_mode = 0; 
        	   	pvPut(ch1_mode); 
			sprintf(Chan1_seq_messages, "Pwr ON");
			pvPut(Chan1_seq_messages); 
			on1_cmd = 1; 
			pvPut(on1_cmd); 						
		} state CLEAR_FAULTS
	}
	state CLEAR_FAULTS {
		when (delay(2)) {
			sprintf(Chan1_seq_messages, "Clr Faults");
			pvPut(Chan1_seq_messages); 
			ch1_clr_flts = 1; 
			pvPut(ch1_clr_flts); 						
		} state WAIT_TO_CLEAR
	}
	state WAIT_TO_CLEAR {
		when (delay(5)) {
			sprintf(Chan1_seq_messages, "Clearing");
			pvPut(Chan1_seq_messages); 
			ch1_clr_flts = 0; 
			pvPut(ch1_clr_flts); 						
		} state PARK_OFF
	}			
	state PARK_OFF {
		when (delay(5)) {
			sprintf(Chan1_seq_messages, "Park OFF");
			pvPut(Chan1_seq_messages); 
			Park = 0; 
			pvPut(Park); 						
		} state DONE_CHECK
	}
	state DONE_CHECK{
		when (ch1_ps_sts == 0) {
			sprintf(Chan1_seq_messages, "FAULTED");
			pvPut(Chan1_seq_messages); 	
			ch1_ps_on_off_sts = 1;	
			pvPut(ch1_ps_on_off_sts); 				
		} state RETRY_ON
		when (ch1_ps_sts == 1) {				
		} state DONE
	}
	state RETRY_ON {
		when (on_cmd==0) {
			Park = 1; 
			ch1_ps_on_off_sts = 1; 
			pvPut(ch1_ps_on_off_sts); 
			sprintf(Chan1_seq_messages, "Try Again");
        	   	pvPut(Chan1_seq_messages);
		} state IDLE
	}
	state DONE {
		when (delay(1)) {
			sprintf(Chan1_seq_messages, "PS Ready");
			pvPut(Chan1_seq_messages); 	
			ch1_ps_on_off_sts = 1;	
			pvPut(ch1_ps_on_off_sts); 				
		} state READY
	}
	state READY {
		when (on_cmd==0) {
			Park = 1; 
			sprintf(Chan1_seq_messages, "Zero DAC");
        	   	pvPut(Chan1_seq_messages);
        	   	ch1_dac_setpoint =0.00; 
        	   	pvPut(ch1_dac_setpoint); 
        	   	ch1_ps_on_off_sts = 0;
        	   	pvPut(ch1_ps_on_off_sts); 
		} state SET_DAC_TO_ZERO_OFF
		when(on_cmd==1) {
			sprintf(Chan1_seq_messages, " PS Ready");
        	   	pvPut(Chan1_seq_messages);
		} state READY
			
	}
	state SET_DAC_TO_ZERO_OFF {
		when ((ch1_dac_rdbck < 0.01) && (ch1_dac_rdbck > -0.05)) {
			sprintf(Chan1_seq_messages, "Pls Wait");
			pvPut(Chan1_seq_messages);  						
		} state POWER_OFF
	}
	state POWER_OFF {
		when (delay(5)) {
			sprintf(Chan1_seq_messages, "Pwr OFF");
			pvPut(Chan1_seq_messages); 
			on1_cmd = 0; 
			pvPut(on1_cmd); 	
			Park = 0; 
			pvPut(Park); 					
		} state COMPLETE
	}
	state COMPLETE {
		when (delay(1)) {
			sprintf(Chan1_seq_messages, "Pwr OFF");
			pvPut(Chan1_seq_messages); 
			ch1_ps_on_off_sts = 1;
			pvPut(ch1_ps_on_off_sts); 
					
		} state INIT
	}
}
