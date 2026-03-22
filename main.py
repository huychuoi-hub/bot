import discord
from discord import app_commands
from discord.ext import commands
import random
import os
from flask import Flask
import threading

app = Flask(__name__)

@app.route("/")
def home():
    return "Bot đang chạy!"

def run_web():
    # Running on port 8080 is often safer for local/cloud environments
    app.run(host="0.0.0.0", port=8080)

# Run Flask in a separate thread to avoid blocking the main script
threading.Thread(target=run_web).start()

# --- CẤU HÌNH ---
TOKEN = os.getenv('DISCORD_BOT_TOKEN')
intents = discord.Intents.default()
intents.members = True # Quan trọng để dùng lệnh ghép đôi

class MyBot(commands.Bot):
    def __init__(self):
        super().__init__(command_prefix="!", intents=intents)

    async def setup_hook(self):
        # Đồng bộ lệnh Slash với Discord
        await self.tree.sync()
        print(f"✅ Đã đồng bộ Slash Commands cho {self.user}")

bot = MyBot()

# --- DỮ LIỆU CÂU HỎI ---
QUIZ_DATA = {
    "trai": [
        { "q": "Bạn thích màu gì nhất?", "opts": ["Xanh/Đen", "Hồng/Tím", "Cầu vồng", "Trắng"] },
        { "q": "Bạn có hay xem TikTok của các anh sáu múi không?", "opts": ["Không", "Thỉnh thoảng", "Nghiện luôn", "Chỉ xem vì nội dung"] },
        { "q": "Bạn nghĩ sao về việc mặc áo đôi với bạn thân nam?", "opts": ["Bình thường", "Hơi kỳ", "Rất thích", "Ước được mặc"] },
        { "q": "Bạn có dùng nước hoa mùi ngọt không?", "opts": ["Không", "Có một ít", "Rất thích mùi này", "Xịt cả ngày"] },
        { "q": "Gu của bạn là nam tính hay thư sinh?", "opts": ["Nữ tính", "Thư sinh", "Cơ bắp", "Ai cũng được"] },
        { "q": "Bạn có hay dỗi bạn thân nam không?", "opts": ["Không bao giờ", "Đôi khi", "Thường xuyên", "Dỗi để được dỗ"] },
        { "q": "Bạn thích để tóc kiểu gì?", "opts": ["Cắt ngắn", "Undercut", "Tóc dài lãng tử", "Nhuộm màu nổi"] },
        { "q": "Khi đi vệ sinh công cộng, bạn có nhìn sang bên cạnh không?", "opts": ["Không!", "Vô tình thấy", "Cố tình nhìn", "So sánh độ lớn"] },
        { "q": "Bạn có thích skinship (đụng chạm) với nam giới không?", "opts": ["Ghét", "Bình thường", "Thích cực", "Chỉ với người đẹp"] },
        { "q": "Bạn có biết nhảy các nhóm nhạc Kpop nữ không?", "opts": ["Không", "Biết 1 vài bài", "Nhảy mượt luôn", "Sát thủ sàn nhảy"] },
        { "q": "Bạn có hay gọi bạn thân là 'vợ' không?", "opts": ["Điên à", "Đùa thôi", "Gọi thật lòng", "Nó gọi mình là vợ"] },
        { "q": "Bạn có thích chụp ảnh tự sướng (selfie) không?", "opts": ["Ít", "Khi cần", "Rất nhiều", "Mọi lúc mọi nơi"] },
        { "q": "Bạn có hay dùng icon ❤️ khi nhắn tin cho nam không?", "opts": ["Không", "Có 🤡", "Dùng suốt", "Tim hồng/tím"] },
        { "q": "Bạn có bao giờ tự hỏi mình có gay không?", "opts": ["Chưa từng", "Đôi khi", "Thường xuyên", "Đang test đây nè"] },
        { "q": "Bạn thích xem phim gì?", "opts": ["Hành động", "Kinh dị", "Tình cảm/Đam mỹ", "Hoạt hình"] },
        { "q": "Bạn có thích được nam giới khen xinh không?", "opts": ["Kỳ cục", "Cũng được", "Sướng rơn", "Khen nữa đi"] },
        { "q": "Bạn có hay đeo phụ kiện lấp lánh không?", "opts": ["Không", "Đồng hồ thôi", "Khuyên tai/Vòng cổ", "Full combo"] },
        { "q": "Cách bạn ngồi thường là gì?", "opts": ["Dáng thẳng", "Gác chân", "Khép nép", "Banh chành"] },
        { "q": "Bạn có thích đi xem show của các 'anh trai' không?", "opts": ["Không", "Có", "Đi vì đam mê", "Đi để ngắm"] },
        { "q": "Bạn có hay chăm sóc da mặt kỹ không?", "opts": ["Rửa nước lã", "Có sữa rửa mặt", "Skincare 7 bước", "Đi spa suốt"] },
        { "q": "Bạn thấy nam giới mặc áo lưới thế nào?", "opts": ["Ghê", "Bình thường", "Sexy", "Muốn mặc thử"] },
        { "q": "Bạn có thích được người khác phái (nam) bảo vệ không?", "opts": ["Tự lo được", "Cũng thích", "Rất cần", "Ước có anh bảo vệ"] },
        { "q": "Bạn có hay xem video hướng dẫn makeup nam không?", "opts": ["Không", "Xem thử", "Nghiên cứu", "Đã làm theo"] },
        { "q": "Bạn thích uống gì nhất?", "opts": ["Rượu/Bia", "Nước ngọt", "Trà sữa/Matcha", "Cocktail"] },
        { "q": "Bạn có sẵn sàng công khai nếu mình Gay không?", "opts": ["Không", "Tùy lúc", "Có thể", "Đang chờ dịp"] }
    ],
    "gai": [
        { "q": "Bạn thích mặc quần hay mặc váy?", "opts": ["Váy", "Quần Jean", "Đồ Oversize", "Suit/Vest"] },
        { "q": "Bạn có hay ga-lăng với bạn nữ khác không?", "opts": ["Không", "Có chút", "Rất hay làm", "Ga-lăng là bản năng"] },
        { "q": "Bạn thích tóc dài hay tóc ngắn?", "opts": ["Dài thướt tha", "Ngang vai", "Tóc tém", "Buzz cut"] },
        { "q": "Bạn có biết sửa bóng đèn/ống nước không?", "opts": ["Không", "Biết sơ sơ", "Tự làm hết", "Thích làm việc đó"] },
        { "q": "Gu của bạn là gì?", "opts": ["Soái ca", "Tỉ tỉ", "Nữ cường", "Gái bánh bèo"] },
        { "q": "Bạn có hay nhìn môi bạn nữ khi nói chuyện không?", "opts": ["Không", "Có nhìn", "Nhìn chằm chằm", "Muốn hôn luôn"] },
        { "q": "Bạn thích chơi thể thao mạnh không?", "opts": ["Ghét", "Cũng được", "Rất thích", "Đang thi đấu"] },
        { "q": "Bạn có hay khen bạn nữ khác xinh không?", "opts": ["Ít", "Có", "Khen suốt", "Khen vì mê"] },
        { "q": "Bạn thấy phim bách hợp thế nào?", "opts": ["Bình thường", "Hay", "Nghiện cực", "Chân ái đời mình"] },
        { "q": "Bạn có thích nắm tay bạn thân nữ không?", "opts": ["Hơi ngại", "Bình thường", "Rất thích", "Nắm mãi không buông"] },
        { "q": "Bạn có thích được gọi là 'chị đại' không?", "opts": ["Không", "Cũng hay", "Thích cực", "Gọi là 'Chồng' cơ"] },
        { "q": "Bạn có hay mua quà cho bạn nữ không?", "opts": ["Khi cần", "Thỉnh thoảng", "Mua suốt", "Mua đồ đôi"] },
        { "q": "Bạn thích phong cách nào?", "opts": ["Bánh bèo", "Cá tính", "Tomboy", "Soft-boy"] },
        { "q": "Bạn có hay bảo vệ bạn nữ khỏi đám con trai không?", "opts": ["Không", "Có", "Luôn luôn", "Ai đụng là chết với mình"] },
        { "q": "Bạn có thích dùng nước hoa mùi gỗ/nam tính không?", "opts": ["Không", "Thử rồi", "Rất thích", "Đang dùng"] },
        { "q": "Bạn có bao giờ nghĩ mình là 'mẹ thiên hạ' không?", "opts": ["Không", "Có chút", "Đúng rồi", "Hơn thế nữa"] },
        { "q": "Bạn thích đi xe gì?", "opts": ["Xe đạp/Bus", "Xe tay ga", "Xe côn tay", "Motor"] },
        { "q": "Bạn có hay xem video của các chị đẹp Kpop không?", "opts": ["Xem nhạc thôi", "Ngắm nhan sắc", "Lưu hình làm nền", "Ước làm người yêu"] },
        { "q": "Bạn có thích cảm giác che chở người khác không?", "opts": ["Thích được che chở", "Bình thường", "Rất thích", "Bản năng của mình"] },
        { "q": "Bạn có hay dùng từ 'vợ' để gọi bạn thân không?", "opts": ["Không", "Có đùa", "Gọi thật", "Hệ thống vợ bé vợ lớn"] },
        { "q": "Bạn thấy con trai có phiền phức không?", "opts": ["Dễ thương mà", "Hơi phiền", "Rất phiền", "Vô hình trong mắt mình"] },
        { "q": "Bạn có thích tập gym/boxing không?", "opts": ["Không", "Có", "Đam mê", "Tập để bảo vệ gái"] },
        { "q": "Bạn có bao giờ muốn thử cắt tóc ngắn hẳn không?", "opts": ["Không bao giờ", "Đã từng nghĩ", "Đang để", "Cắt từ lâu rồi"] },
        { "q": "Bạn thích đi đâu vào cuối tuần?", "opts": ["Shopping", "Cafe bánh bèo", "Đi phượt", "Đi bar ngắm gái"] },
        { "q": "Bạn có sẵn sàng là một Les chính hiệu không?", "opts": ["Không", "Có thể", "Xác định rồi", "Les từ bé"] }
    ]
}

# --- VIEW CHO QUIZ ---
class QuizView(discord.ui.View):
    def __init__(self, user_id, gender, questions, step=0):
        super().__init__(timeout=180)
        self.user_id = user_id
        self.gender = gender
        self.questions = questions
        self.step = step
        self.update_select_menu()

    def update_select_menu(self):
        self.clear_items()
        item = self.questions[self.step]
        options = [discord.SelectOption(label=opt, value=str(i)) for i, opt in enumerate(item['opts'])]
        
        select = discord.ui.Select(
            placeholder=f"Câu {self.step + 1}/25: Chọn câu trả lời...",
            options=options
        )
        select.callback = self.handle_selection
        self.add_item(select)

    async def handle_selection(self, interaction: discord.Interaction):
        if interaction.user.id != self.user_id:
            return await interaction.response.send_message("Này, bài test này không phải của bạn!", ephemeral=True)

        self.step += 1
        if self.step < len(self.questions):
            self.update_select_menu()
            embed = discord.Embed(
                title=f"Câu {self.step + 1}/{len(self.questions)}",
                description=f"### {self.questions[self.step]['q']}",
                color=0xFF69B4
            )
            await interaction.response.edit_message(embed=embed, view=self)
        else:
            # Kết quả ngẫu nhiên vui vẻ
            res = random.randint(70, 100)
            label = "GAY" if self.gender == "trai" else "LES"
            await interaction.response.edit_message(
                content=f"📊 Kết quả: **{interaction.user.display_name}** có độ **{label}** là `{res}%`!\n*(Lưu ý: Kết quả chỉ mang tính chất giải trí)*",
                embed=None, view=None
            )

class GenderView(discord.ui.View):
    def __init__(self):
        super().__init__(timeout=60)

    @discord.ui.select(
        placeholder="Chọn giới tính để bắt đầu...",
        options=[
            discord.SelectOption(label="Nam (Gay Test)", value="trai", emoji="♂️"),
            discord.SelectOption(label="Nữ (Les Test)", value="gai", emoji="♀️")
        ]
    )
    async def select_gender(self, interaction: discord.Interaction, select: discord.ui.Select):
        gender = select.values[0]
        questions = QUIZ_DATA[gender].copy()
        random.shuffle(questions)
        
        view = QuizView(interaction.user.id, gender, questions[:25])
        embed = discord.Embed(
            title="Câu 1/25",
            description=f"### {questions[0]['q']}",
            color=0xFF69B4
        )
        await interaction.response.edit_message(content=None, embed=embed, view=view)

# --- SLASH COMMANDS ---

@bot.tree.command(name="gay", description="Bài test độ cong 25 câu ngẫu nhiên")
async def gay_cmd(interaction: discord.Interaction):
    await interaction.response.send_message(
        "🧪 **Bắt đầu bài kiểm tra hệ tư tưởng...**", 
        view=GenderView(), 
        ephemeral=True
    )

@bot.tree.command(name="bau_cua", description="Chơi Bầu Cua Cá Cọp")
@app_commands.choices(chon=[
    app_commands.Choice(name="Bầu 🍐", value="Bầu"),
    app_commands.Choice(name="Cua 🦀", value="Cua"),
    app_commands.Choice(name="Cá 🐟", value="Cá"),
    app_commands.Choice(name="Gà 🐔", value="Gà"),
    app_commands.Choice(name="Tôm 🦐", value="Tôm"),
    app_commands.Choice(name="Nai 🦌", value="Nai")
])
async def bau_cua(interaction: discord.Interaction, chon: str):
    icons = {'Bầu': '🍐', 'Cua': '🦀', 'Cá': '🐟', 'Gà': '🐔', 'Tôm': '🦐', 'Nai': '🦌'}
    results = [random.choice(list(icons.keys())) for _ in range(3)]
    win_count = results.count(chon)
    
    res_str = " | ".join([icons[r] for r in results])
    msg = f"🎲 **Kết quả:** {res_str}\n"
    msg += f"🎉 Thắng x{win_count} **{chon}**!" if win_count > 0 else f"💸 Không có con **{chon}** nào."
    await interaction.response.send_message(msg)

@bot.tree.command(name="gepcap", description="Tìm kiếm nửa kia ngẫu nhiên")
async def gepcap(interaction: discord.Interaction):
    members = [m for m in interaction.guild.members if not m.bot and m.id != interaction.user.id]
    if not members:
        return await interaction.response.send_message("Server này không có ai để ghép cả!")
    
    partner = random.choice(members)
    await interaction.response.send_message(f"💞 Đã ghép đôi <@{interaction.user.id}> với <@{partner.id}>! Hợp nhau đấy!")

@bot.tree.command(name="avt", description="Soi ảnh đại diện")
async def avt(interaction: discord.Interaction, user: discord.User = None):
    target = user or interaction.user
    await interaction.response.send_message(target.display_avatar.url)

@bot.tree.command(name="ti_le_doi", description="Xem bói tỉ lệ thoát ế")
async def ti_le_doi(interaction: discord.Interaction):
    rate = random.randint(0, 100)
    await interaction.response.send_message(f"💖 Tỉ lệ thoát ế của bạn là: **{rate}%**")

bot.run(TOKEN)
