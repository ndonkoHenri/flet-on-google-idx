import flet as ft


def main(page: ft.Page):
    page.title = "Flet counter example"
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    def handle_minus_click(e: ft.ControlEvent):
        counter.value = str(int(counter.value) - 1)
        page.update()

    def handle_plus_click(e: ft.ControlEvent):
        counter.value = str(int(counter.value) + 1)
        page.update()

    counter = ft.TextField(value="0", text_align=ft.TextAlign.RIGHT, width=100)

    page.add(
        ft.Row(
            alignment=ft.MainAxisAlignment.CENTER,
            controls=[
                ft.IconButton(ft.icons.REMOVE, on_click=handle_minus_click),
                counter,
                ft.IconButton(ft.icons.ADD, on_click=handle_plus_click),
            ],
        )
    )


ft.app(main, view=ft.AppView.WEB_BROWSER)
