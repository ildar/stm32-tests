#include <string.h>
#include "main.h"
#include "stm32f1xx_hal.h"
#include "stm32f1xx_hal_gpio.h"

extern UART_HandleTypeDef huart1;
extern PCD_HandleTypeDef hpcd_USB_FS;

static const char* STR_GREET1 = "\r\nHello, UART user!\r\n--\r\n";

void _main(void)
{
	char c, buf[] = "[_]";

	HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
	HAL_UART_Transmit(&huart1, STR_GREET1, strlen(STR_GREET1), HAL_MAX_DELAY);
	HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);

	while ( HAL_UART_Receive(&huart1, &c, 1, 500) ) {
		HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
		HAL_UART_Transmit(&huart1, ".", 1, HAL_MAX_DELAY);
		HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
//		HAL_Delay(500);
	}
	HAL_UART_Transmit(&huart1, "\n\r", 2, HAL_MAX_DELAY);

	while(1) {
		while ( HAL_UART_Receive(&huart1, &buf[1], 1, 100) );
		HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
		HAL_UART_Transmit(&huart1, buf, 3, HAL_MAX_DELAY);
		HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
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

