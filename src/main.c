//
// Blink a LED
//
#include "stm32f103xb.h"

//
// Delay function:
// Uses the SysTick timer to wait for
// an arbitrary time in microseconds.
//
// The clock source is assumed to be
// the internal 8MHz RC oscillator
// divided by 8 (1MHz)
//
void delay_us(unsigned int time)
{
	//
	// Load the delay period in microseconds
	// assuming a 1MHz source
	//
	SysTick->LOAD = time;

	//
	// Clears the current value and the count flag
	//
	SysTick->VAL = 0;
	
	//
	// Waits until the count ends
	//
	while(!(SysTick->CTRL & SysTick_CTRL_COUNTFLAG_Msk));
}

int main()
{
	//
	// Enable all Ports and Alternate Function clocks
	//
	RCC->APB2ENR |= RCC_APB2ENR_IOPAEN | RCC_APB2ENR_IOPBEN |
	    RCC_APB2ENR_IOPCEN | RCC_APB2ENR_IOPDEN | RCC_APB2ENR_AFIOEN;
	
	//
	//Disable JTAG and SWO (Free PB3, PB4 and PA15)
	//
	AFIO->MAPR = AFIO_MAPR_SWJ_CFG_JTAGDISABLE;

	//
	//Enable the SysTick Timer with
	//the CPU clock divided by 8
	
	SysTick->CTRL = SysTick_CTRL_ENABLE_Msk;

	//
	// Enable the PA1 as a digital output
	//
	GPIOA->CRL = 0x00000020;

	//
	//Infinite loop
	//
	while(1)
	{
		GPIOA->BSRR = GPIO_BSRR_BS1; //PA1 = 1 (Led OFF)
		delay_us(500000); //500ms delay
		GPIOA->BSRR = GPIO_BSRR_BR1; //PA1 = 0 (Led ON)
		delay_us(500000); //500ms delay
	}
}
