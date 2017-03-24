#include <string.h>
#include "main.h"
#include "stm32f1xx_hal.h"
#include "stm32f1xx_hal_gpio.h"

extern UART_HandleTypeDef huart1;
extern PCD_HandleTypeDef hpcd_USB_FS;

static const char* STR_GREET1 = "\r\nHello, UART user!\r\n--\r\n";

void print(char* s) { // blinks while printnig to UART
	HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
	HAL_UART_Transmit(&huart1, (uint8_t*) s, strlen(s), HAL_MAX_DELAY);
	HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
}

void _main(void)
{
	char c, buf[] = "[_]";

	print(STR_GREET1);

	while ( HAL_UART_Receive(&huart1, &c, 1, 500) ) {
		print(".");
//		HAL_Delay(500);
	}
	print("\n\r");

	while(1) {
		while ( HAL_UART_Receive(&huart1, &buf[1], 1, 100) );
		print(buf);
		if(buf[1]=='}')
			HAL_NVIC_SystemReset();
	}
}
/**
  * @brief  This function is executed in case of error occurrence.
  * @param  None
  * @retval None
  */
void _Error_Handler(void)
{
}

#ifdef USE_FULL_ASSERT
/**
   * @brief Reports the name of the source file and the source line number
   * where the assert_param error has occurred.
   * @param file: pointer to the source file name
   * @param line: assert_param error line source number
   * @retval None
   */
void _assert_failed(uint8_t* file, uint32_t line)
{
}

#endif

