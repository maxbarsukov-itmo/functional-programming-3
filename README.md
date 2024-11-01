# Лабораторная работа 3

[![Elixir](https://github.com/maxbarsukov-itmo/functional-programming-3/actions/workflows/elixir.yml/badge.svg?branch=master)](https://github.com/maxbarsukov-itmo/functional-programming-3/actions/workflows/elixir.yml)
[![Markdown](https://github.com/maxbarsukov-itmo/functional-programming-3/actions/workflows/markdown.yml/badge.svg?branch=master)](https://github.com/maxbarsukov-itmo/functional-programming-3/actions/workflows/markdown.yml)
[![Coverage Status](https://coveralls.io/repos/github/maxbarsukov-itmo/functional-programming-3/badge.svg?branch=master)](https://coveralls.io/github/maxbarsukov-itmo/functional-programming-3?branch=master)

<img alt="bumps" src="./.resources/anime.gif" height="280">

> [!TIP]
> Ah shit, here we go again...

---

  * Студент: `Барсуков Максим Андреевич`
  * Группа: `P3315`
  * ИСУ: `367081`
  * Функциональный язык: `Elixir`

---

## Описание работы

**Цель**: получить навыки работы с *вводом/выводом*, *потоковой обработкой данных*, *командной строкой*.

В рамках лабораторной работы вам предлагается повторно реализовать лабораторную работу по предмету *«Вычислительная математика»*,посвящённую **интерполяции** (в разные годы это лабораторная работа 3 или 4) со следующими дополнениями:

  * обязательно должна быть реализована **линейная интерполяция** ([отрезками](https://en.wikipedia.org/wiki/Linear_interpolation));
  * настройки алгоритма интерполяции и выводимых данных должны задаваться через **аргументы командной строки**:
    * какие **алгоритмы** использовать (в том числе два сразу);
    * **частота дискретизации** результирующих данных;
    * и т.п.;
  * входные данные должны задаваться в **текстовом формате** на подобии `.csv` (к примеру `x;y\n` или `x\ty\n`) и подаваться на **стандартный ввод**, входные данные должны быть отсортированы по возрастанию `x`;
  * выходные данные должны подаваться на **стандартный вывод**;
  * программа должна работать в **потоковом режиме** (пример -- `cat | grep 11`), это значит, что при запуске программы она должна ожидать получения данных на стандартный ввод, и, по мере получения достаточного количества данных, должна выводить рассчитанные точки в стандартный вывод;

#### Архитектура

Приложение должно быть организовано следующим образом:

```text
    +---------------------------+
    | обработка входного потока |
    +---------------------------+
            |
            | поток / список / последовательность точек
            v
    +-----------------------+      +------------------------------+
    | алгоритм интерполяции |<-----| генератор точек, для которых |
    +-----------------------+      | необходимо вычислить         |
            |                      | промежуточные значения       |
            |                      +------------------------------+
            |
            | поток / список / последовательность рассчитанных точек
            v
    +------------------------+
    | печать выходных данных |
    +------------------------+
```

#### Потоковый режим

Потоковый режим для алгоритмов, работающих с группой точек должен работать следующим образом:

```text
o o o o o o . . x x x
  x x x . . o . . x x x
    x x x . . o . . x x x
      x x x . . o . . x x x
        x x x . . o . . x x x
          x x x . . o . . x x x
            x x x . . o o o o o o EOF
```

где:

  * **каждая строка -- окно данных**, на основании которых производится расчёт алгоритма;
  * строки сменяются по мере поступления в систему новых данных (старые данные удаляются из окна, новые -- добавляются);
  * `o` -- рассчитанные данные, можно видеть:
    * большинство окон используется для расчёта всего одной точки, так как именно в "центре" результат наиболее точен;
    * первое и последнее окно используются для расчёта большого количества точек, так лучших данных для расчёта у нас не будет.
  * `.` -- точки, задействованные в рассчете значения o.
  * `x` -- точки, расчёт которых для "окон" не требуется.

#### Пример

Пример вычислений для шага `1.0` и функции `sin(x)`:

```ocaml
Ввод первых двух точек (в данном примере X Y через пробел):
0 0.00
1.571 1

Вывод:
Линейная (идем от первой точки из введенных (0.00) с шагом 1, покрывая все введенные X (1.571 < 2)):
0.00    1.00    2.00
0.00    0.64    1.27

Ввод третьей точки:
3.142 0

Следующий вывод:
Линейная (идем от второй точки из введенных (1.571) с шагом 1, покрывая все введенные X (3.142 < 3.57)):
1.57    2.57    3.57
1.00    0.36    -0.27

Ввод четвертой точки:
4.712 -1

Следующий вывод:
Линейная (идем от третьей точки из введенных (3.142) с шагом 1, покрывая все введенные X (4.712 < 5.14)):
3.14    4.14    5.14
0.00    -0.64   -1.27

Лагранж (теперь количество введенных точек повзоляет его рассчитать, идем от первой точки (0.00) из введенных с шагом 1, покрывая все введенные X (4.712 < 5)):
0.00    1.00    2.00    3.00    4.00    5.00
0.00    0.97    0.84    0.12    -0.67   -1.03

И т.д.
```

Как видно из примера выше, **окна для каждого метода двигаются по-разному**.

Для *линейной* окно начало сдвигаться уже при вводе третьей точки (т.к. для вычисления нужно всего две), в то время как для *Лагранжа* окно начало двигаться только когда была введена пятая точка (т.к. здесь для вычислений нужно больше точек).

## Требования

**Общие требования**:

  * программа должна быть реализована в функциональном стиле;
  * ввод/вывод должен быть отделён от алгоритмов интерполяции;
  * требуется использовать идиоматичный для технологии стиль программирования.

**Содержание отчёта**:

  * титульный лист;
  * требования к разработанному ПО, включая описание алгоритма;
  * ключевые элементы реализации с минимальными комментариями;
  * ввод/вывод программы;
  * выводы (отзыв об использованных приёмах программирования).

**Общие рекомендации по реализации**. Не стоит писать большие и страшные автоматы, управляющие поведением приложения в целом. Если у вас:

  * Язык с ленью -- используйте лень.
  * Языки с параллельным программированием и акторами -- используйте их.
  * Язык без всей этой прелести -- используйте генераторы/итераторы/и т.п.

---

## Выполнение

### Архитектура приложения

```text
+---------------------------+
|   Обработка конфигурации  |
|   и аргументов программы  |
+---------------------------+
             |
             | Конфигурация шага и точности
             v
+---------------------------+
| Обработка входного потока |<----+
+---------------------------+     |
             |                    |
             +--------------------+
             |
             | Новая точка
             v
+---------------------------+
|   Валидация новой точки   |
+---------------------------+             +-----------------+
|                           |<------------| Генерация точек |
|       Интерполяция        |             +-----------------+
|                           |-----------+
+---------------------------+  Метод 1  |
             |        |-----------------+
             |        |        Метод 2  |
             |        |-----------------+
             |        |        ...      |
             |        |-----------------+
             |
             |
             | Результаты вычислений
             v
+---------------------------+
|  Печать выходных значений |
+---------------------------+
```

### Ключевые элементы реализации

Линейная интерполяция:

```elixir
defmodule InterpolationApp.Algo.LinearInterpolation do
  use InterpolationApp.Algo.Interpolation

  @impl true
  def get_name, do: "Линейная интерполяция"

  @impl true
  def get_enough_points_count, do: 2

  @impl true
  def need_concrete_number_of_points?, do: true

  @impl true
  def interpolate(points, x) when not is_list(x) do
    [{x0, y0}, {x1, y1}] = points

    a = (y1 - y0) / (x1 - x0)
    b = y0 - a * x0

    {x, a * x + b}
  end
end
```

REPL:

```elixir
defmodule InterpolationApp.CLI.Repl do
  alias InterpolationApp.CLI.{Applier, Interpolator, Printer}

  def start(config) do
    IO.puts("Введите 'quit', чтобы закончить ввод.")
    IO.puts("Введите узлы интерполяции:")

    {:ok, printer_pid} = Printer.start_link(config)
    {:ok, interpolator_pid} = Interpolator.start_link(config, printer_pid)
    {:ok, applier_pid} = Applier.start_link(interpolator_pid)

    loop(applier_pid)
  end

  defp loop(applier_pid) do
    :io.setopts(:standard_io, active: true)
    input = IO.gets("") |> check_quit

    GenServer.cast(applier_pid, {:apply_input, String.trim(input)})
    loop(applier_pid)
  end

  ...
end
```

GenServer интерполяции:

```elixir
defmodule InterpolationApp.CLI.Interpolator do
  use GenServer

  alias InterpolationApp.Utils.PointGenerator

  # Client API

  def start_link(config, printer_pid) do
    GenServer.start_link(__MODULE__, {config, printer_pid}, name: __MODULE__)
  end

  def add_point(point) do
    GenServer.cast(__MODULE__, {:add_point, point})
  end

  # Server Callbacks

  @impl true
  def init({config, printer_pid}) do
    {:ok, {[], config, printer_pid}}
  end

  @impl true
  def handle_cast({:add_point, point}, {points, config, printer_pid}) do
    points = Enum.reverse([point | Enum.reverse(points)])

    Enum.each(config.methods, fn method ->
      handle_method(method, points, printer_pid, config)
    end)

    {:noreply, {points, config, printer_pid}}
  end

  # Helper Functions

  defp handle_method(method, points, printer_pid, config) do
    if method.points_enough?(points) do
      limit = method.get_enough_points_count()

      interpolation_points =
        if method.need_concrete_number_of_points?(),
          do: Enum.slice(points, -limit, limit),
          else: points

      generated_points = PointGenerator.generate(interpolation_points, config.step)

      GenServer.cast(printer_pid, {
        :print,
        method,
        method.interpolate(interpolation_points, generated_points)
      })
    end

    :ok
  end
end
```

### Как запустить?

**1.** Склонировать репозиторий:

```bash
git clone git@github.com:maxbarsukov-itmo/functional-programming-3.git
```

**2.** Установить зависимости:

```bash
mix deps.get
mix deps.compile
```

**3.** Собрать `escript` — исполняемый файл, который может быть запущен на любой системе с установленным Erlang.:

```bash
mix escript.build
```

**4.** Линтинг:

```bash
mix check
```

**5.** Тестирование:

```bash
mix test --trace
```

**6.** Запустить приложение: `./out/interpolation-app`

Help message:

```text
usage: interpolation-app [options] --methods=<method1,method2,...> --step=<step>
options:
  -h, --help              Prints this message
  --accuracy=<accuracy>   Set printing accuracy

methods:
  * linear
  * lagrange3
  * lagrange4
  * newton
```

### Пример работы программы

Для значений из [data/sin_x.csv](./data/sinx.csv):

```bash
cat data/sinx.csv | ./out/interpolation-app --methods=linear,newton,lagrange4 --step=1 --accuracy=3
```

```ocaml
❯ ./out/interpolation-app --methods=linear,newton,lagrange4 --step=1
Введите 'quit', чтобы закончить ввод.
Введите узлы интерполяции:
0 0
1.571 1
>> Линейная интерполяция (идем от точки из введенных 0.0 с шагом 1.0, покрывая все введенные X)
0.000   1.000   2.000   
0.000   0.637   1.273   

>> Интерполяция по Ньютону (идем от точки из введенных 0.0 с шагом 1.0, покрывая все введенные X)
0.000   1.000   2.000   
0.000   0.637   1.273   

3.142 0
>> Линейная интерполяция (идем от точки из введенных 1.571 с шагом 1.0, покрывая все введенные X)
1.571   2.571   3.571   
1.000   0.363   -0.273  

>> Интерполяция по Ньютону (идем от точки из введенных 0.0 с шагом 1.0, покрывая все введенные X)
0.000   1.000   2.000   3.000   4.000   
0.000   0.868   0.925   0.173   -1.391  

4.712 -1
>> Линейная интерполяция (идем от точки из введенных 3.142 с шагом 1.0, покрывая все введенные X)
3.142   4.142   5.142   
0.000   -0.637  -1.274  

>> Интерполяция по Ньютону (идем от точки из введенных 0.0 с шагом 1.0, покрывая все введенные X)
0.000   1.000   2.000   3.000   4.000   5.000   
0.000   0.973   0.841   0.120   -0.674  -1.026  

>> Интерполяционный многочлен Лагранжа для 4 точек (идем от точки из введенных 0.0 с шагом 1.0, покрывая все введенные X)
0.000   1.000   2.000   3.000   4.000   5.000   
0.000   0.973   0.841   0.120   -0.674  -1.026  

12.568 0
>> Линейная интерполяция (идем от точки из введенных 4.712 с шагом 1.0, покрывая все введенные X)
4.712   5.712   6.712   7.712   8.712   9.712   10.712  11.712  12.712  
-1.000  -0.873  -0.745  -0.618  -0.491  -0.364  -0.236  -0.109  0.018   

>> Интерполяция по Ньютону (идем от точки из введенных 0.0 с шагом 1.0, покрывая все введенные X)
0.000   1.000   2.000   3.000   4.000   5.000   6.000   7.000   8.000   9.000   10.000  11.000  12.000  13.000  
0.000   1.001   0.825   0.114   -0.637  -1.083  -1.031  -0.436  0.595   1.806   2.792   2.996   1.712   -1.916  

>> Интерполяционный многочлен Лагранжа для 4 точек (идем от точки из введенных 1.571 с шагом 1.0, покрывая все введенные X)
1.571   2.571   3.571   4.571   5.571   6.571   7.571   8.571   9.571   10.571  11.571  12.571  
1.000   0.373   -0.280  -0.915  -1.486  -1.950  -2.262  -2.378  -2.254  -1.845  -1.107  0.004   

quit

Спасибо за использование программы!

      |      _,,,---,,_
ZZZzz /,`.-'`'    -.  ;-;;,_
    |,4-  ) )-,_. , (  `'-'
    '---''(_/--'  `-'_)

```

### Форматирование, линтинг и тестирование

В рамках данной работы были применены инструменты:

  * [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) - для модульного тестирования;
  * [Quixir](https://github.com/pragdave/quixir) - для тестирования свойств (property-based).
  * [Credo](https://github.com/rrrene/credo) - инструмент статического анализа кода для языка Elixir;
  * [Dialyxir](https://github.com/jeremyjh/dialyxir) - Dialy~~zer~~xir is a **DI**screpancy **A**na**LY**zer for ~~**ER**lang~~ Eli**XIR** programs.

---

## Выводы

В ходе работы были разработаны и протестированы алгоритмы для различных методов интерполяции и вспомогательные утилиты. 

Достигнуты следующие результаты:

  * С использованием параллелизма и серверов OTP была разработана утилита для асинхронного подсчёта интерполяции.
  * Реализованы алгоритмы интерполяции (линейная, Лагранжа и Ньютона) с использованием подходов для работы с заданным количеством точек.
  * Созданы утилиты для генерации промежуточных точек, проверки входных данных и конфигурации CLI.
  * Подтверждена корректность работы модулей при различных входных данных, в том числе при случайных значениях (property-based тесты).

---

## Полезные ссылки

| Ссылка | Описание |
| --- | --- |
| [github.com/maxbarsukov/itmo/4 вычмат/лабораторные/lab5](https://github.com/maxbarsukov/itmo/tree/master/4%20%D0%B2%D1%8B%D1%87%D0%BC%D0%B0%D1%82/%D0%BB%D0%B0%D0%B1%D0%BE%D1%80%D0%B0%D1%82%D0%BE%D1%80%D0%BD%D1%8B%D0%B5/lab5) | Вычмат: ЛР 5 по интерполяции функции |
| [en.wikipedia.org/wiki/Interpolation](https://en.wikipedia.org/wiki/Interpolation) | Что такое интерполяция? |
| [elixirschool.com/ru/lessons/intermediate/concurrency](https://elixirschool.com/ru/lessons/intermediate/concurrency) | Параллелизм в Elixir |
| [elixirschool.com/ru/lessons/advanced/otp_concurrency](https://elixirschool.com/ru/lessons/advanced/otp_concurrency) | Параллелизм в OTP |
| [habr.com/ru/articles/114232/](https://habr.com/ru/articles/114232/) | Erlang и его процессы |
| [perso.ens-lyon.fr/laurent.modolo/unix/7_streams_and_pipes.html](https://perso.ens-lyon.fr/laurent.modolo/unix/7_streams_and_pipes.html) | Unix Streams and pipes |

## Лицензия <a name="license"></a>

Проект доступен с открытым исходным кодом на условиях [Лицензии MIT](https://opensource.org/license/mit/). \
*Авторские права 2024 Max Barsukov*

**Поставьте звезду :star:, если вы нашли этот проект полезным.**
