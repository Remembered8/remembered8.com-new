<?php

namespace App\Filament\Resources\Contributions\Tables;

use Filament\Actions\Action;
use Filament\Actions\BulkAction;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Collection;

/**
 * The moderation queue.
 *
 * Memory letters arrive unapproved, so this table is where a guardian decides
 * what joins the public record. Everything else is already published and shown
 * here for context.
 */
class ContributionsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('memorial.full_name')
                    ->label('Dossier')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('kind')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'memory' => 'warning',
                        'candle' => 'info',
                        'tree' => 'success',
                        default => 'gray',
                    }),

                TextColumn::make('author_name')
                    ->label('From')
                    ->searchable()
                    ->description(fn ($record): ?string => $record->relation ?: null)
                    ->placeholder('Anonymous'),

                TextColumn::make('body')
                    ->label('Words')
                    ->limit(80)
                    ->wrap()
                    ->searchable()
                    ->placeholder('No text'),

                IconColumn::make('is_approved')
                    ->label('Published')
                    ->boolean(),

                TextColumn::make('created_at')
                    ->label('Left')
                    ->since()
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                TernaryFilter::make('is_approved')
                    ->label('Published')
                    ->placeholder('Everything')
                    ->trueLabel('Published only')
                    ->falseLabel('Awaiting a decision'),

                SelectFilter::make('kind')->options([
                    'candle' => 'Candle',
                    'memory' => 'Memory letter',
                    'flower' => 'Flower',
                    'tree' => 'Tree',
                    'prayer' => 'Condolence',
                ]),
            ])
            ->recordActions([
                Action::make('approve')
                    ->label('Publish')
                    ->icon(Heroicon::CheckCircle)
                    ->color('success')
                    ->visible(fn ($record): bool => ! $record->is_approved)
                    ->action(fn ($record) => $record->update(['is_approved' => true]))
                    ->successNotificationTitle('Published to the memorial.'),

                Action::make('unapprove')
                    ->label('Withdraw')
                    ->icon(Heroicon::EyeSlash)
                    ->color('gray')
                    ->requiresConfirmation()
                    ->visible(fn ($record): bool => $record->is_approved && $record->kind === 'memory')
                    ->action(fn ($record) => $record->update(['is_approved' => false]))
                    ->successNotificationTitle('Withdrawn from public view.'),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    BulkAction::make('approveSelected')
                        ->label('Publish selected')
                        ->icon(Heroicon::CheckCircle)
                        ->color('success')
                        ->action(fn (Collection $records) => $records->each->update(['is_approved' => true]))
                        ->deselectRecordsAfterCompletion(),

                    // A tribute someone left is not casual to destroy.
                    DeleteBulkAction::make()->requiresConfirmation(),
                ]),
            ]);
    }
}
