import flet as ft
import shutil
class FilePicker(ft.Container):

    def did_mount(self):
        self.page.overlay.append(self.file_picker)
        self.page.overlay.append(self.path_picker)
        self.page.update()
        return super().did_mount()

    def pick_files(self, e):
        if e.control.data == "file":
            self.file_picker.pick_files(
                "Pick a File"
            )
        else:
            self.path_picker.get_directory_path(
                "Pick a Path",
            )

    def pick_path_result(self, e):
        print(e.path and self.selected_path)
        if e.path and self.selected_path:
            # shutil.copy2(self.selected_path, e.path)
            self.page.open(ft.SnackBar(ft.Text(f"Copied to {e.path}")))
            return

    def pick_file_result(self, e):
        # for i, f in enumerate():
        #     print(i, )
        # print(e)
        if not e.files:
            return
        self.info_text.value = f"{e.files[0].name}"
        self.path_text.value = f"{e.files[0].path}"
        self.selected_path = e.files[0].path
        self.size_text.value = f"{e.files[0].size}"
        self.button_path_pick.disabled = False
        self.update()

    def __init__(self):
        super().__init__()
        self.picked_file = None
        self.picked_path = None
        self.selected_path = None
        self.info_text = ft.Text(" ", text_align=ft.TextAlign.JUSTIFY)
        self.path_text = ft.Text(" ", text_align=ft.TextAlign.JUSTIFY)
        self.size_text = ft.Text(" ", text_align=ft.TextAlign.JUSTIFY)
        self.file_picker = ft.FilePicker(on_result=self.pick_file_result)
        self.path_picker = ft.FilePicker(on_result=self.pick_path_result)
        self.button_file_pick = ft.Button("Pick File", on_click=self.pick_files, data="file")
        self.button_path_pick = ft.Button("Pick Path", on_click=self.pick_files, disabled=True, data="path")

        self.content = ft.Column(
            [
                ft.Container(
                    padding=10,
                    alignment=ft.alignment.center,
                    bgcolor=ft.Colors.with_opacity(0.3, ft.Colors.PRIMARY_CONTAINER),
                    content=ft.Column(
                        [
                            ft.Row(),
                            ft.Container(
                                padding=3,
                                content=ft.Text("Name"),
                                bgcolor=ft.Colors.with_opacity(0.3, ft.Colors.PRIMARY_CONTAINER),
                                border_radius=5,
                                border=ft.border.all(1, ft.Colors.with_opacity(0.5, ft.Colors.PRIMARY))
                            ),
                            self.info_text,
                            ft.Container(
                                padding=3,
                                content=ft.Text("Path"),
                                bgcolor=ft.Colors.with_opacity(0.3, ft.Colors.PRIMARY_CONTAINER),
                                border_radius=5,
                                border=ft.border.all(1, ft.Colors.with_opacity(0.5, ft.Colors.PRIMARY))
                            ),
                            self.path_text,
                            ft.Container(
                                padding=3,
                                content=ft.Text("Size"),
                                bgcolor=ft.Colors.with_opacity(0.3, ft.Colors.PRIMARY_CONTAINER),
                                border_radius=5,
                                border=ft.border.all(1, ft.Colors.with_opacity(0.5, ft.Colors.PRIMARY))
                            ),
                            self.size_text
                        ],
                        expand=True,
                        horizontal_alignment=ft.CrossAxisAlignment.START
                    )
                ),
                self.button_file_pick,
                self.button_path_pick,
            ],
            horizontal_alignment=ft.CrossAxisAlignment.CENTER
        )

def main(page: ft.Page):
    page.title = "Fle Picker"
    page.theme_mode = ft.ThemeMode.LIGHT
    page.vertical_alignment = ft.MainAxisAlignment.START
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.theme = ft.Theme(
        color_scheme_seed=ft.Colors.random()
    )
    page.appbar = ft.AppBar(
        title=ft.Text("File Picker"),
        center_title=True,
        bgcolor=ft.colors.PRIMARY_CONTAINER,
    )



    page.add(FilePicker())


ft.app(main, view=ft.AppView.WEB_BROWSER)
