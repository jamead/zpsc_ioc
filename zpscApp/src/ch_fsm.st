/* Sequencer to control the PSC IOC startup.*/

#define PRINTF seqLog
#define RES_M 0.000077
#define RES_H 0.000020

program ch_fsm ("M0=lab{2}, M1=Chan1")


/* ============================================================
   Options
   ------------------------------------------------------------
   +r : Reentrant (allows multiple instances)
   -c : Do not wait for all assigned PVs to connect at startup
   ============================================================ */
   
option +r;
option -c;

double fabs(double);


short DAC; 
assign DAC to "{M0}{M1}:DAC_SetPt-SP"; 
monitor DAC; 

short DAC_rdbck; 
assign DAC_rdbck to "{M0}{M1}:DAC-I"; 
monitor DAC_rdbck; 

short Park; 
assign Park to "{M0}{M1}:DigOut_Park-SP";
monitor Park;

/*Will need to be updated for channel to channel unipolar/bipolar operation */
short Polarity; 
assign Polarity to "{M0}Polarity-Mode"; 
monitor Polarity; 

short flt_mask; 
assign flt_mask to "{M0}{M1}:FaultMask:B12-SP"; 
monitor flt_mask; 

short flt_clr; 
assign flt_clr to "{M0}{M1}:FaultClear-SP"; 
monitor flt_clr; 

short ps_on_off; 
assign ps_on_off to "{M0}{M1}:PSOnOff-SP"; 
monitor ps_on_off; 

short ps_on_off_sts; 
assign ps_on_off_sts to "{M0}{M1}:PSOnOff-STS"; 
monitor ps_on_off_sts; 

short ps_on_sts_bip; 
assign ps_on_sts_bip to "{M0}{M1}:DigIn-I.B0"; 
monitor ps_on_sts_bip; 

short ps_on_sts_uni; 
assign ps_on_sts_uni to "{M0}{M1}:DigIn-I.B1"; 
monitor ps_on_sts_uni; 

short on1_cmd; 
assign on1_cmd to "{M0}{M1}:DigOut_ON1-SP"; 

short ch1_en_cmd; 
assign ch1_en_cmd to "{M0}Chan1:DigOut_ON2-SP";
monitor ch1_en_cmd; 

short ch2_en_cmd; 
assign ch2_en_cmd to "{M0}Chan2:DigOut_ON2-SP";
monitor ch2_en_cmd; 

short ch3_en_cmd; 
assign ch3_en_cmd to "{M0}Chan3:DigOut_ON2-SP";
monitor ch3_en_cmd; 

short ch4_en_cmd; 
assign ch4_en_cmd to "{M0}Chan4:DigOut_ON2-SP";
monitor ch4_en_cmd; 

short sum_fault; 
assign sum_fault to "{M0}{M1}:FaultsLat-I"; 
monitor sum_fault; 

short autozero; 
assign autozero to "{M0}{M1}:AutoZero-SP"; 
monitor autozero; 

double dcct1_adc; 
assign dcct1_adc to "{M0}{M1}:DCCT1-I";
monitor dcct1_adc; 

double dcct1_ofst; 
assign dcct1_ofst to "{M0}{M1}:DCCT1-Offset-SP"; 
monitor dcct1_ofst; 

double dcct2_adc; 
assign dcct2_adc to "{M0}{M1}:DCCT2-I";
monitor dcct2_adc; 

double dcct2_ofst; 
assign dcct2_ofst to "{M0}{M1}:DCCT2-Offset-SP"; 
monitor dcct2_ofst; 

short mode; 
assign mode to "{M0}{M1}:DAC_OpMode-adj_countSP";
monitor mode;  

double error_adc; 
assign error_adc to "{M0}{M1}:Error-I"; 
monitor error_adc; 

double dac_ofst; 
assign dac_ofst to "{M0}{M1}:DACSetPt-Offset-SP";  
monitor dac_ofst; 

short scale_factor; 
assign scale_factor to "{M0}{M1}:SF:DAC_DCCTs-I";
monitor scale_factor;  

short res; 
assign res to "{M0}Resolution-Mode"; 
monitor res; 

short avg_mode; 
assign avg_mode to "{M0}{M1}:AveMode-SP"; 
monitor avg_mode; 

short atzo_sts; 
assign atzo_sts to "{M0}{M1}:AutoZero-STS"; 
monitor atzo_sts; 

/* stringout to display status or progress. */
string Chan_seq_messages;  
assign Chan_seq_messages to "{M0}{M1}_seq_messages";

string atzo_messages; 
assign atzo_messages to "{M0}{M1}_atzo_messages"; 

string atzo_dbg1_messages; 
assign atzo_dbg1_messages to "{M0}{M1}_atzo_dbg1_messages"; 

string atzo_dbg2_messages; 
assign atzo_dbg2_messages to "{M0}{M1}_atzo_dbg2_messages"; 

string atzo_dbg3_messages; 
assign atzo_dbg3_messages to "{M0}{M1}_atzo_dbg3_messages"; 

int from_faulted_state; 
double error_old; 
double error_new; 
unsigned int up; 
int push; 
int adj_count; 

    /*******************************/
   /*    Initialization Phase     */
  /*******************************/
ss OFF_ON_FSM {

    state INIT_1 {
    	when(){
    	  flt_mask = 1; 
    	  pvPut(flt_mask); 
    	  DAC = 0; 
    	  pvPut(DAC); 
          ps_on_off_sts = 0;
          pvPut(ps_on_off_sts);
          Park = 1;
          pvPut(Park);
    	  on1_cmd = 0; 
	  pvPut(on1_cmd);  
          ch1_en_cmd = 1; 
          pvPut(ch1_en_cmd);  
          ch2_en_cmd = 1; 
          pvPut(ch2_en_cmd);  
          ch3_en_cmd = 1; 
          pvPut(ch3_en_cmd); 
          ch4_en_cmd = 1; 
          pvPut(ch4_en_cmd); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "WAIT...1");
          pvPut(Chan_seq_messages);
    	} state INIT_2
    }
    state INIT_2 {
    	when(delay(3)) {
          ch1_en_cmd = 1; 
          pvPut(ch1_en_cmd);  
          ch2_en_cmd = 1; 
          pvPut(ch2_en_cmd);  
          ch3_en_cmd = 1; 
          pvPut(ch3_en_cmd); 
          ch4_en_cmd = 1; 
          pvPut(ch4_en_cmd); 
          flt_mask = 0; 
    	  pvPut(flt_mask); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "WAIT...2");
          pvPut(Chan_seq_messages);
    	} state INIT_3
    }
    state INIT_3 {
    	when(delay(2)) {
          flt_mask = 1; 
    	  pvPut(flt_mask); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "WAIT...3");
       	  pvPut(Chan_seq_messages);
    	} state INIT_4
    }
    state INIT_4 {
    	when(delay(2)) {
          flt_clr = 1; 
    	  pvPut(flt_clr); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "Clearing Faults");
       	  pvPut(Chan_seq_messages);
    	} state INIT_5
    }
    state INIT_5 {
    	when(delay(5)) {
          flt_clr = 0; 
    	  pvPut(flt_clr); 
    	  printf("Initializing OFF_ON_FSM...\n");
          //sprintf(Chan_seq_messages, "Clear Done");
       	  pvPut(Chan_seq_messages);
    	} state IDLE
    }
    
    /*******************************/
   /* Sequencer for Bipolar PSC   */
  /*******************************/
    state IDLE {
       when(autozero ==1) {
       		atzo_sts = 1; 
       		pvPut(atzo_sts); 
       		sprintf(atzo_messages, "Zeroing DCCT Offsets");
       	    	pvPut(atzo_messages);
       	    	avg_mode = 0; 
       	    	pvPut(avg_mode); 
       	    	dcct1_ofst = 0;
       	    	pvPut(dcct1_ofst); 
       	    	dcct2_ofst = 0; 
       	    	pvPut(dcct2_ofst);
       	    	dac_ofst = 0; 
       	    	pvPut(dac_ofst);        	    	
       } state READBACK_DCCT1_ADC_OFFSET
        when(ps_on_off == 1) {
		Park = 1; 
		pvPut(Park); 
		DAC = 0.0; 
		pvPut(DAC); 
		ps_on_off_sts = 0;
            	pvPut(ps_on_off_sts); 
            	sprintf(Chan_seq_messages, "Zeroing DAC");
       	    	pvPut(Chan_seq_messages);
       	    } state SET_DAC_TO_ZERO_ON
       	when(ps_on_off == 0) {
       	     if(from_faulted_state == 0) {
		//ps_on_off_sts = 1;
        	//pvPut(ps_on_off_sts); 
             } else {
                //ps_on_off_sts = 2;
        	//pvPut(ps_on_off_sts); 
             }
	        sprintf(Chan_seq_messages, "PS OFF");
       	    	pvPut(Chan_seq_messages);
        } state CHECK_IF_SYSTEM_WAS_FAULTED
    }
        
    state CHECK_IF_SYSTEM_WAS_FAULTED {
    	when(from_faulted_state == 0){
    		ps_on_off_sts = 1;
        	pvPut(ps_on_off_sts); 
    	    } state IDLE
    	when(from_faulted_state == 1) { //System has previously faulted and we are retrying
    		from_faulted_state = 0; 
		Park = 1; 
		pvPut(Park); 
		DAC = 0.0; 
		pvPut(DAC); 
		ps_on_off_sts = 0;
            	pvPut(ps_on_off_sts); 
            	sprintf(Chan_seq_messages, "Zeroing DAC");
       	    	pvPut(Chan_seq_messages);    		
    	} state SET_DAC_TO_ZERO_ON
    }
    	
    state SET_DAC_TO_ZERO_ON {
		when ((DAC_rdbck < 0.01) && (DAC_rdbck > -0.01)) {
	        	sprintf(Chan_seq_messages, "Zeroing DAC");
	        	pvPut(Chan_seq_messages);  
	        	DAC =0.000; 
            		pvPut(DAC); 						
		} state CLEAR_FAULTS
    }    
    
    state CLEAR_FAULTS {
		when (delay(2)) {
			sprintf(Chan_seq_messages, "Clearing Faults");
			pvPut(Chan_seq_messages); 
			flt_clr = 1; 
			pvPut(flt_clr); 
			ch1_en_cmd = 1; 
          		pvPut(ch1_en_cmd);  
          		ch2_en_cmd = 1; 
          		pvPut(ch2_en_cmd);  
          		ch3_en_cmd = 1; 
          		pvPut(ch3_en_cmd); 
          		ch4_en_cmd = 1; 
          		pvPut(ch4_en_cmd); 						
		} state WAIT_TO_CLEAR
	}
	state WAIT_TO_CLEAR {
		when (delay(5)) {
			sprintf(Chan_seq_messages, "Clearing Faults");
			pvPut(Chan_seq_messages); 
			flt_clr = 0; 
			pvPut(flt_clr); 						
		} state POWER_ON
	}	
    	state POWER_ON {
    		when(delay(2)){
    	   		on1_cmd = 1; 
	   		pvPut(on1_cmd); 
	   		sprintf(Chan_seq_messages, "Powering ON");
	   		pvPut(Chan_seq_messages); 
    		} state PARK_OFF
    	}		
	state PARK_OFF {
		when (delay(8)) {
			sprintf(Chan_seq_messages, "Park OFF");
			pvPut(Chan_seq_messages); 
			Park = 0; 
			pvPut(Park); 						
		} state CHECK_TYPE //DONE_CHECK
	}
        state CHECK_TYPE {
        	when(Polarity == 0){
        	} state DONE_CHECK_BIPOLAR
        	when(Polarity == 1){
        	} state DONE_CHECK_UNIPOLAR
        }
	state DONE_CHECK_BIPOLAR{
		when (ps_on_sts_bip == 0) {	
			//printf("ps_on_sts = %d\n",ps_on_sts); 
			from_faulted_state = 1; 
			ps_on_off_sts = 0;	
			pvPut(ps_on_off_sts); 				
		} state RETRY_ON
		when (ps_on_sts_bip == 1) {	
		//printf("ps_on_sts = %d\n",ps_on_sts); 			
		} state DONE
	}
	state DONE_CHECK_UNIPOLAR{
		when (ps_on_sts_uni == 0) {	
			//printf("ps_on_sts = %d\n",ps_on_sts); 
			from_faulted_state = 1; 
			ps_on_off_sts = 0;	
			pvPut(ps_on_off_sts); 				
		} state RETRY_ON
		when (ps_on_sts_uni == 1) {	
		//printf("ps_on_sts = %d\n",ps_on_sts); 			
		} state DONE
	}
	state RETRY_ON {
		when (ps_on_off==0) {
			ps_on_off_sts = 2; 
			pvPut(ps_on_off_sts); 
			on1_cmd = 0; 
			pvPut(on1_cmd); 
			sprintf(Chan_seq_messages, "Faulted..Try Again");
        		pvPut(Chan_seq_messages);
        	    } state RETRY_IDLE
       }
       state RETRY_IDLE {
        	when (ps_on_off==1) {
        		ps_on_off_sts = 2; 
			pvPut(ps_on_off_sts);
			on1_cmd = 0; 
			pvPut(on1_cmd); 
        		sprintf(Chan_seq_messages, "Faulted..Try Again");
        		pvPut(Chan_seq_messages);
        	    } state INIT_1 
	}
	state DONE {
		when (delay(1)) {
			sprintf(Chan_seq_messages, " PS Ready!");
			pvPut(Chan_seq_messages); 	
			ps_on_off_sts = 1;	
			pvPut(ps_on_off_sts); 				
		} state READY
	}
	state READY {
		when (ps_on_off==1) {
			sprintf(Chan_seq_messages, "Zeroing DAC");
        	   	pvPut(Chan_seq_messages);
        	   	DAC =0.00; 
        	   	pvPut(DAC); 
        	   	ps_on_off_sts = 0;
        	   	pvPut(ps_on_off_sts); 
		} state SET_DAC_TO_ZERO_OFF
		when(ps_on_off==0) {
        	   	ps_on_off_sts = 1;
        	   	pvPut(ps_on_off_sts); 
			sprintf(Chan_seq_messages, " PS Ready!");
        	   	pvPut(Chan_seq_messages);
		} state CHECK_FAULT
	}
	state CHECK_FAULT {
		when(sum_fault == 0){
		} state READY
		when(sum_fault > 0) {
			from_faulted_state = 1; 
			ps_on_off_sts = 2; 
			pvPut(ps_on_off_sts); 
			sprintf(Chan_seq_messages, "Faulted..Try Again"); 
		} state RETRY_ON
	}
	state SET_DAC_TO_ZERO_OFF {
		when ((DAC_rdbck < 0.01) && (DAC_rdbck > -0.05)) {
			sprintf(Chan_seq_messages, "Turning OFF");
			pvPut(Chan_seq_messages);  						
		} state POWER_OFF
	}
	state POWER_OFF {
		when (delay(5)) {
			sprintf(Chan_seq_messages, "Turning OFF");
			pvPut(Chan_seq_messages); 
			on1_cmd = 0; 
			pvPut(on1_cmd); 	
			Park = 1; 
			pvPut(Park); 					
		} state COMPLETE
	}
	state COMPLETE {
		when (delay(1)) {
			sprintf(Chan_seq_messages, "Power OFF");
			pvPut(Chan_seq_messages); 
			ps_on_off_sts = 1;
			pvPut(ps_on_off_sts); 				
		} state IDLE
	}

    /*******************************/
   /* Auto-Zero Procedure*/
  /*******************************/
	state READBACK_DCCT1_ADC_OFFSET{
		when(delay(3)) {
			pvGet(dcct1_adc);
			dcct1_ofst = dcct1_adc; 
        	   	pvPut(dcct1_ofst);
            		sprintf(atzo_messages, "%f Offset",dcct1_adc);
       	    		pvPut(atzo_messages);
		} state CHECK_DCCT1
	}
	state WAIT1{
		when(delay(4)) {
		} state CHECK_DCCT1
	}
	state CHECK_DCCT1 {
		when(dcct1_adc < fabs(0.001)){
		       sprintf(atzo_messages, "DCCT1 GOOD");
       	    	       pvPut(atzo_messages);
		} state READBACK_DCCT2_ADC_OFFSET
		when(dcct1_adc > fabs(0.001)){
		       sprintf(atzo_messages, "DCCT1 RETRY");
       	    	       pvPut(atzo_messages);
		} state READBACK_DCCT1_ADC_OFFSET
	}
	state READBACK_DCCT2_ADC_OFFSET{
		when(4) {
			pvGet(dcct2_adc);
			dcct2_ofst = dcct2_adc; 
        	   	pvPut(dcct2_ofst);
            		sprintf(atzo_messages, "%f Offset",dcct2_adc);
       	    		pvPut(atzo_messages);
		} state WAIT2
	}
	state WAIT2{
		when(delay(3)) {
		} state CHECK_DCCT2
	}
	state CHECK_DCCT2 {
		when(dcct2_adc < fabs(0.001)){
		       sprintf(atzo_messages, "DCCT2 GOOD");
       	    	       pvPut(atzo_messages);
		} state JUMP_MODE
		when(dcct1_adc > fabs(0.001)){
		       sprintf(atzo_messages, "DCCT2 RETRY");
       	    	       pvPut(atzo_messages);
		} state READBACK_DCCT2_ADC_OFFSET
	}
	state JUMP_MODE {
		when() {
		   mode = 3; 
		   pvPut(mode); 
		   sprintf(atzo_messages, "DAC ADJUSTMENT");
       	    	   pvPut(atzo_messages);
       	    	   pvGet(error_adc);		   
		} state WAIT3
	}
	state WAIT3{
		when(delay(3)){
		   pvGet(error_adc); 
		   adj_count = 0; 
		   error_old = fabs(error_adc); 
		   sprintf(atzo_messages, "%f ERROR1",error_adc);
       	    	   pvPut(atzo_messages);
		} state INCREMENT_UP
	}
/*	state ZERO_ERROR_CHECK {
		when(fabs(error_adc) < fabs(0.01)){
			pvGet(error_adc); 
			pvPut(dac_ofst);  
			sprintf(atzo_messages, "DONE");
       	    	   	pvPut(atzo_messages);
		} state IDLE
		when(fabs(error_adc) > fabs(0.01)){
			pvGet(error_adc); 
			error_old = fabs(error_adc); 
			sprintf(atzo_messages, "UP");
       	    	   	pvPut(atzo_messages);			
		} state INCREMENT_UP
	}*/
	state INCREMENT_UP {
		when(fabs(error_adc) < 0.01){
			sprintf(atzo_messages, "COMPLETE");
       	    	   	pvPut(atzo_messages);	
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
			} state IDLE
		when(fabs(error_adc) > 0.01) {
			//up = 1; 
			adj_count = adj_count +1; 
       	    	   	pvGet(error_adc);
       	    	   	error_old = fabs(error_adc); 
       	    	   	if(res == 0){
       	    	   		dac_ofst = dac_ofst + (RES_M*scale_factor) + push; 
       	    	   	}else{
				dac_ofst = dac_ofst + (RES_H*scale_factor) + push; 
			}
			pvPut(dac_ofst); 
			sprintf(atzo_messages, "push = %d, adj_count = %d", push, adj_count);
       	    	   	pvPut(atzo_messages);
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
			} state WAIT4
		} 
	state INCREMENT_DOWN {
		when(fabs(error_adc) < 0.01){
			adj_count = 0; 
			mode = 0; 
			atzo_sts = 0; 
			pvPut(atzo_sts); 
			//up = 0; 
			pvPut(mode); 
			sprintf(atzo_messages, "COMPLETE");
       	    	   	pvPut(atzo_messages);	
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state IDLE
		when(fabs(error_adc) > 0.01) {
			adj_count = adj_count +1; 
       	    	   	pvGet(error_adc);
       	    	   	error_old = fabs(error_adc); 
       	    	   	if(res == 0){
       	    	   		dac_ofst = dac_ofst - (RES_M*scale_factor); 
       	    	   	}else{
				dac_ofst = dac_ofst - (RES_H*scale_factor); 
			}
			pvPut(dac_ofst); 
			sprintf(atzo_messages, "DOWN");
       	    	   	pvPut(atzo_messages);	
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/	
			} state WAIT4
		} 		
	state WAIT4 {
		when(delay(1)) {
			pvGet(error_adc); 
			error_new = fabs(error_adc); 	
			//error_new = error_adc; 
			sprintf(atzo_messages, "WAIT4");
       	    	   	pvPut(atzo_messages);	
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state WAIT5
	}
	state WAIT5 {
		when(delay(1)) {
			sprintf(atzo_messages, "WAIT5");
       	    	   	pvPut(atzo_messages);	
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state CHECK_NEW_ERROR
	}
	state CHECK_NEW_ERROR {
		when(adj_count > 85) {
			adj_count = 0; 
			atzo_sts = 0; 
			pvPut(atzo_sts); 
			sprintf(atzo_messages, "NON-CONVERGENT!");
       	    	   	pvPut(atzo_messages);
		} state IDLE
		when(error_new < error_old) {
       	    	   	//adj_count = 0; 
			up = up; 
			error_old = error_new; //fabs(error_adc);
			sprintf(atzo_messages, "CHECK");
       	    	   	pvPut(atzo_messages);	
       	    	   	push = 0; 
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/	
		} state UP_DOWN
		when(error_new > error_old) {
			if(up ==1){
			    up = 0; 
			}else{
			    up = 1; 
			}
			error_old = error_new; //fabs(error_adc);
			sprintf(atzo_messages, "CHECK");
       	    	   	pvPut(atzo_messages);	
       	    	   	push = 0; 
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state WAIT6
		when(error_new == error_old) {
			up = up; 
			push = 2*(RES_M*scale_factor);  //extra push if error did not move
			error_old = error_new; //fabs(error_adc);
			sprintf(atzo_messages, "CHECK");
       	    	   	pvPut(atzo_messages);	
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state WAIT6
	}
	state WAIT6 {
		when(delay(1)) {
			sprintf(atzo_messages, "WAIT6, UP %d",up);
       	    	   	pvPut(atzo_messages);
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
       	    	}state UP_DOWN	
	} 
	state UP_DOWN {
		when(up >0) {
			sprintf(atzo_messages, "ZERO CHECK");
       	    	   	pvPut(atzo_messages);
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state INCREMENT_UP
		when(up ==0) {
			sprintf(atzo_messages, "ZERO CHECK");
       	    	   	pvPut(atzo_messages);
       	    	   	/***********************/
       	    	   	sprintf(atzo_dbg1_messages, "%f ErrNew",error_new); 
       	    	   	pvPut(atzo_dbg1_messages); 
       	    	   	sprintf(atzo_dbg2_messages, "%f ErrOld",error_old); 
       	    	   	pvPut(atzo_dbg2_messages); 	
       	    	        sprintf(atzo_dbg3_messages, "%f ErrAdc",error_adc); 
       	    	   	pvPut(atzo_dbg3_messages); 
       	    	   	/***********************/
		} state INCREMENT_DOWN
	}
		/*
		when((fabs(error_adc) > fabs(0.0001)) && (error_adc > 0.0)) {
			pvGet(error_adc); 
			dac_ofst = dac_ofst - 0.000001; 
			pvPut(dac_ofst); 
			sprintf(atzo_messages, "ADJUSTING...");
       	    	   	pvPut(atzo_messages);
		} state ZERO_ERROR
		when((fabs(error_adc) > fabs(0.0001)) && (error_adc < 0.0)){
			pvGet(error_adc); 
			dac_ofst = dac_ofst + 0.000001; 
			pvPut(dac_ofst); 
			sprintf(atzo_messages, "ADJUSTING...");
       	    	   	pvPut(atzo_messages);
		} state ZERO_ERROR
		*/
}
	
    /*******************************/
   /* Sequencer for Unipolar PSC  */
  /*******************************/
/*
    state UNIPOLAR_IDLE {
        when(delay(1.0)) {
            printf("Set %s to 1\n", pvName(Park));
            sprintf(Chan_seq_messages, "IDLE 2CH");
       	    pvPut(Chan_seq_messages);
        } state UNIPOLAR_IDLE
    }
*/


