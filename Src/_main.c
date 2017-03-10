#include "main.h"
#include "stm32f1xx_hal.h"
#include "stm32f1xx_hal_gpio.h"
#include <string.h>
#include <stdarg.h>

extern UART_HandleTypeDef huart1;
extern PCD_HandleTypeDef hpcd_USB_FS;

extern int test_main (int argc, const char* argv[]);

static const char* STR_GREET1 = "\r\nHello, UART user!\r\n--\r\n";

int printf(const char* format, ...) { // blinks while printnig to UART
	va_list args;
	int sz;
	char prbuf[80];
	HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
	va_start( args, format );
	sz=vsnprintf(prbuf, sizeof(prbuf), format, args);
	HAL_UART_Transmit(&huart1, (uint8_t*)prbuf, (sz>80)?80:sz, HAL_MAX_DELAY);
	va_end( args );
	HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
}

void _main(void)
{
	uint8_t c;

	printf(STR_GREET1);

	while ( HAL_UART_Receive(&huart1, &c, 1, 500) ) {
		printf(".");
	}

	while(1) {
		printf("\n\r");
		test_main(0, NULL);
		HAL_Delay(5000);
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

